#!/bin/sh

# cloudflared binary install path
CLOUDFLARED_BIN="/usr/local/bin/cloudflared"

# Function to write script logs to console in correct order with cloudflared logs
log() {
    printf '%s\n' "$*" >&2
}

# Fetch the latest cloudflared version and download URL
fetch_latest_release() {
    latest_release_json=$(curl -fsSL https://api.github.com/repos/cloudflare/cloudflared/releases/latest) || return 1
    LATEST_VERSION=$(printf '%s' "$latest_release_json" | jq -r '.tag_name') || return 1
    LATEST_URL=$(printf '%s' "$latest_release_json" | jq -r '.assets[] | select(.browser_download_url | endswith("cloudflared-linux-amd64")) | .browser_download_url') || return 1

    if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ] || [ -z "$LATEST_URL" ] || [ "$LATEST_URL" = "null" ]; then
        return 1
    fi
}

# Extract the local cloudflared version; return an empty string on failure
get_local_version() {
    if [ ! -x "$CLOUDFLARED_BIN" ]; then
        return 0
    fi

    "$CLOUDFLARED_BIN" --version 2>/dev/null | grep -Eo '[0-9]{4}\.[0-9]+\.[0-9]+' | head -n 1
}

# Download and install the cloudflared binary
install_cloudflared() {
    curl -L --output "cloudflared" "$LATEST_URL" && \
    chmod +x ./cloudflared && \
    mv ./cloudflared "$CLOUDFLARED_BIN"
}

# Check if TUNNEL_TOKEN is set, if not, use token
if [ -z "$TUNNEL_TOKEN" ]; then
    if [ -z "$token" ]; then
        log "Error: 'TUNNEL_TOKEN' environment variable is not set."
        exit 1
    else
        log "Warning: 'TUNNEL_TOKEN' should be used instead of 'token'."
        TUNNEL_TOKEN="$token"
    fi
fi

# Fetch the latest remote release metadata and keep the existing failure behavior
if ! fetch_latest_release; then
    log "Error: Failed to fetch the latest cloudflared release metadata."
    exit 1
fi

LOCAL_VERSION=$(get_local_version)

# Install when the binary is missing; update only when the local version is behind
if [ ! -x "$CLOUDFLARED_BIN" ]; then
    log "cloudflared binary not found, downloading version: $LATEST_VERSION"
    install_cloudflared || exit 1
elif [ "$LOCAL_VERSION" != "$LATEST_VERSION" ]; then
    log "Updating cloudflared from version $LOCAL_VERSION to $LATEST_VERSION"
    install_cloudflared || exit 1
else
    # Reuse the local binary when it is already up to date
    log "Using existing cloudflared binary: $CLOUDFLARED_BIN (version: $LOCAL_VERSION)"
fi

# Start cloudflared
log "Starting cloudflared tunnel"
exec "$CLOUDFLARED_BIN" tunnel run --token "$TUNNEL_TOKEN"
