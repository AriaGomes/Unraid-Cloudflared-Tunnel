#!/bin/sh

# Function to handle cleanup
cleanup() {
    # Add any cleanup tasks here
    kill -9 $pid  # Forcefully terminate cloudflared
    exit 0
}

# Trap signals and call cleanup function
trap cleanup SIGINT SIGTERM

# Check if TUNNEL_TOKEN is set, if not, use token
if [ -z "$TUNNEL_TOKEN" ]; then
    if [ -z "$token" ]; then
        echo "Error: 'TUNNEL_TOKEN' environment variable is not set."
        exit 1
    else
        echo "Warning: 'TUNNEL_TOKEN' should be used instead of 'token'."
        TUNNEL_TOKEN="$token"
    fi
fi
# Download and install cloudflared
url=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | jq -r '.assets[] | select(.browser_download_url | endswith("cloudflared-linux-amd64")) | .browser_download_url') && \
curl -L --output "cloudflared" $url && \
chmod +x ./cloudflared && \
mv ./cloudflared /usr/local/bin/
# Start cloudflared with TUNNEL_TOKEN or fallback to token
cloudflared tunnel run --token $TUNNEL_TOKEN &
pid=$!

# Function to wait for cloudflared process to terminate
wait_cloudflared() {
    wait $pid
}

# Trap EXIT signal to wait for cloudflared process to terminate
trap wait_cloudflared EXIT

# Wait for the script to be terminated
wait
