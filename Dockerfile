FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libbz2-dev \
    unzip \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/ablab/spades/archive/91e6772.zip \
  && unzip 91e6772.zip \
  && mv /spades-91e6772de90c20133138fc8cbbaba19abf3da950 /spades

WORKDIR /spades

RUN bash spades_compile.sh

# Stage 2: Runtime Stage
FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Docker image for Spades"
LABEL org.opencontainers.image.authors="Julien FOURET"
LABEL org.opencontainers.image.description="https://github.com/ablab/spades/"
LABEL org.opencontainers.image.vendor="Nexomis"
LABEL org.opencontainers.image.licenses="GPLv2"

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libbz2-1.0 \
    libc6 \
    libgcc-s1 \
    libgomp1 \
    libhat-trie0 \
    libnlopt0 \
    libssw0 \
    libstdc++6 \
    python3-distutils \
    python3-joblib \
    python3-yaml \
    samtools \
    bwa \
    bamtools \
    python3 \
    wget \
    ca-certificates \
    gzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /spades/bin/* /usr/local/bin/
COPY --from=builder /spades/share/spades /usr/local/share/spades
