# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install build dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    cmake \
    git \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libgflags-dev \
    gperf \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the source code
COPY . /app

# Build the telegram-bot-api
RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . --target telegram-bot-api -- -j$(nproc)

# Install the binary
RUN cd build && make install

# Command to run the telegram-bot-api
CMD ["/usr/local/bin/telegram-bot-api", "--local", "--dir", "/app/data"]
