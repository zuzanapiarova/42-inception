# GITHUB ACTIONS RUNNER

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    jq \
    git \
    sudo \
    libicu67 \
    libkrb5-3 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Create runner user and working dir
RUN useradd -m runner && \
    mkdir -p /runner && \
    chown -R runner:runner /runner

WORKDIR /runner

# download and extract GitHub Actions runner - trying here form script so it only runs once - 
# TODO: put version into env and into build arguments - does not work for some reason even tho its there
RUN mkdir actions-runner && \
    cd actions-runner && \
    echo "Running actions-runner-linux-x64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz"  && \
    curl -fsSL --retry 5 --retry-delay 10 -o actions-runner-linux-x64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz  && \
    echo "downloaded"  && \
    tar xzf ./actions-runner-linux-x64-2.328.0.tar.gz  && \
    echo "Expanded"  && \
    rm ./actions-runner-linux-x64-2.328.0.tar.gz  && \
    echo "removed tar"

# Copy entrypoint as root
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Drop privileges afterwards
USER runner

ENTRYPOINT ["/entrypoint.sh"]