package st_logger

import (
	"bytes"
	"io"
	"log"
	"os"
)

var logger *log.Logger

const (
	INFO  = iota
	ERROR = iota
	FATAL = iota
	DEBUG = iota
)

func InitializeLogger(log_destination string) {
	var output io.Writer

	if log_destination == "stdout" {
		output = os.Stdout
	} else {
		file, err := os.OpenFile(log_destination, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
		if err != nil {
			log.Fatalln("Failed to open log file", log_destination, ":", err)
		}
		output = file
	}

	logger = log.New(output,
		"",
		log.Ldate|log.Ltime)
}

func WriteLogMessage(level int, message ...string) {
	var buffer bytes.Buffer
	switch level {
	case INFO:
		buffer.WriteString("info : ")
	case ERROR:
		buffer.WriteString("error : ")
	case FATAL:
		buffer.WriteString("fatal : ")
	case DEBUG:
		buffer.WriteString("debug : ")
	}

	for _, m := range message {
		buffer.WriteString(m)
		buffer.WriteString(" ")
	}

	if buffer.Len() > 0 {
		buffer.Truncate(buffer.Len() - 1)
	}

	logger.Println(buffer.String())

	if level == FATAL {
		logger.Println("fatal error occurred, exiting")
		os.Exit(1)
	}
}
