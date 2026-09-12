FROM debian:bookworm AS builder

ARG CADVISOR_VERSION=v0.60.5
ARG GO_VERSION=1.25.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        build-essential \
        gcc \
        git \
        make && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm -f /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /build

RUN git clone --depth 1 --branch ${CADVISOR_VERSION} \
        https://github.com/google/cadvisor.git . && \
    make build

#todo: explain why am i doing multistage build 
FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/_output/cadvisor /usr/local/bin/cadvisor

EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/cadvisor"]