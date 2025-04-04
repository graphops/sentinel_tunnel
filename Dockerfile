# Build stage
FROM golang:1-bullseye AS build-image

# Update and install necessary packages
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     wget \
#     curl \
#     libpq-dev \
#     pkg-config \
#     libssl-dev \
#     clang \
#     build-essential \
#     libc6-dev \
#     ca-certificates \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# Copy project to the container
COPY . /sentinel_tunnel
WORKDIR /sentinel_tunnel


# Build the Go project
RUN go build sentinel_tunnelling_client.go

# Download and install UPX
#RUN wget https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-amd64_linux.tar.xz \
#    && tar -xJf upx-4.0.2-amd64_linux.tar.xz \
#    && mv upx-4.0.2-amd64_linux/upx /usr/local/bin \
#    && rm -rf upx-4.0.2-amd64_linux* \
#    && upx --overlay=strip --best /subgraph-extensions-service/target/release/subgraph-extensions-service

# Runtime stage
FROM debian:bullseye-slim AS runtime

# Install CA certificates
#RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy necessary files from build-image
COPY --from=build-image /sentinel_tunnel/sentinel_tunnelling_client /usr/local/bin/sentinel_tunnel
#COPY --from=build-image /usr/share/zoneinfo /usr/share/zoneinfo

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/sentinel_tunnel"]
