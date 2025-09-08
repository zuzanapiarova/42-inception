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
RUN mkdir actions-runner
RUN cd actions-runner
RUN echo "Running actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUN curl -fsSL --retry 5 --retry-delay 10 -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN echo "downloaded"
RUN tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN echo "Expanded"
RUN rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN echo "removed tar"

# Copy entrypoint as root
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Drop privileges afterwards
USER runner

ENTRYPOINT ["/entrypoint.sh"]