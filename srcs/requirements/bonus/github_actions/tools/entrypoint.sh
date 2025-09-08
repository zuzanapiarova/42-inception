#! /bin/bash

set -e

echo "Starting"

# required env vars for runner process: GITHUB_URL, RUNNER_TOKEN
if [ -z "$GITHUB_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Error: GITHUB_URL and RUNNER_TOKEN must be set as environment variables."
  exit 1
fi

# # in GitHub repo, select Settings -> Actions -> Self-hosted and use the generated commands here:
# if [ ! -d actions-runner ]; then
#   mkdir actions-runner
# fi
# cd actions-runner

# # download and extract GitHub Actions runner
# echo "Running actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
# curl -fsSL --retry 5 --retry-delay 10 -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# echo "downloaded"

# tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# echo "Expanded"
# rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# echo "removed tar"

# if [ -x ./bin/installdependencies.sh ]; then # -x check so your script won’t crash if installdependencies.sh isn’t there yet
#   echo "Installing runner dependencies..."
#   sudo ./bin/installdependencies.sh
#   echo "Dependencies installed"
# else
#   echo "Warning: ./bin/installdependencies.sh not found!"
# fi

# configure the runner (only if not already configured)
if [ ! -f .runner ]; then
  ./config.sh \
    --unattended \
    --url "$GITHUB_URL" \
    --token "$RUNNER_TOKEN" \
    --name "${RUNNER_NAME:-$(hostname)}" \
    --work "${RUNNER_HOME}/_work" \
    --labels inception-runner
fi
echo "Configured"

# run official GitHub Actions runner binary
exec ./run.sh