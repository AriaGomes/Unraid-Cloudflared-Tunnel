#!/bin/sh

# Function to handle cleanup
cleanup() {
    # Add any cleanup tasks here
    kill -9 $pid  # Forcefully terminate cloudflared
    exit 0
}

# Trap signals and call cleanup function
trap cleanup SIGINT SIGTERM

# Ensure token is set
if [ -z "$token" ]; then
    echo "Error: 'token' environment variable is not set."
    exit 1
fi

# Start cloudflared
cloudflared tunnel --no-autoupdate run --token $token &
pid=$!

# Function to wait for cloudflared process to terminate
wait_cloudflared() {
    wait $pid
}

# Trap EXIT signal to wait for cloudflared process to terminate
trap wait_cloudflared EXIT

# Wait for the script to be terminated
wait
