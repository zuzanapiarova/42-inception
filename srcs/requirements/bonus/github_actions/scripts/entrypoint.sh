#! /bin/bash

set -e

cd /runner/actions-runner
echo "Starting"

# required env vars for runner process: GITHUB_URL, RUNNER_TOKEN
if [ -z "$GITHUB_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Error: GITHUB_URL and RUNNER_TOKEN must be set as environment variables."
  exit 1
fi

# get new github token
# echo "Getting runner token ..."
# curl --request GET \
#     --url "https://api.github.com/user" \
#     --header "Accept: application/vnd.github+json" \
#     --header "Authorization: Bearer $USER_ACCESS_TOKEN" \
#     --header "X-GitHub-Api-Version: 2022-11-28"
# echo "Got runner token"

# configure the runner (only if not already configured)
if [ ! -f .runner ]; then
  ./config.sh \
    --unattended \
    --url "$GITHUB_URL" \
    --token "$RUNNER_TOKEN" \
    --name "${RUNNER_NAME:-$(hostname)}" \
    --work "$RUNNER_HOME/_work" \
    --labels "self-hosted,inception-runner,docker,linux"
fi
echo "Configured"

# run official GitHub Actions runner binary
exec ./run.sh