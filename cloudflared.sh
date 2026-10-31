#!/bin/sh

# cloudflared binary install path
APPDATA_DIR="/appdata"
CLOUDFLARED_BIN="$APPDATA_DIR/cloudflared"

# Function to write script logs to console in correct order with cloudflared logs
log() {
    printf '%s\n' "$*" >&2
}

# Fetch the latest cloudflared version and download URL.
fetch_latest_release() {
    LATEST_VERSION=""
    LATEST_URL=""

    latest_release_json=$(curl -fsSL --connect-timeout 10 --max-time 30 --retry 2 \
        https://api.github.com/repos/cloudflare/cloudflared/releases/latest) || return 1
    LATEST_VERSION=$(printf '%s' "$latest_release_json" | jq -r '.tag_name // empty') || return 1
    LATEST_URL=$(printf '%s' "$latest_release_json" | jq -r '[.assets[]? | select(.name == "cloudflared-linux-amd64")][0].browser_download_url // empty') || return 1

    [ -n "$LATEST_VERSION" ] && [ -n "$LATEST_URL" ]
}

# Extract the local cloudflared version; return an empty string on failure
get_local_version() {
    if [ ! -x "$CLOUDFLARED_BIN" ]; then
        return 0
    fi

    "$CLOUDFLARED_BIN" --version 2>/dev/null | grep -Eo '[0-9]{4}\.[0-9]+\.[0-9]+' | head -n 1
}

# Download and install the cloudflared binary.
# use temporary file to avoid overwriting the existing binary if the download fails for any reason.
install_cloudflared() {
    tmp_bin="${CLOUDFLARED_BIN}.download"
    rm -f "$tmp_bin"

    if curl -fsSL --connect-timeout 15 --speed-limit 1024 --speed-time 30 \
            --output "$tmp_bin" "$LATEST_URL" &&
        chmod +x "$tmp_bin" &&
        "$tmp_bin" --version >/dev/null 2>&1 &&
        mv -f "$tmp_bin" "$CLOUDFLARED_BIN"; then
        return 0
    fi

    rm -f "$tmp_bin"
    return 1
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

# Make sure the install directory exists
mkdir -p "$APPDATA_DIR" || log "Warning: Could not create $APPDATA_DIR."

LOCAL_VERSION=$(get_local_version)
CURRENT_VERSION="${LOCAL_VERSION:-unknown}"

if fetch_latest_release; then
    # Install when the binary is missing; update only when the local version is behind
    if [ ! -x "$CLOUDFLARED_BIN" ]; then
        log "cloudflared binary not found, downloading version: $LATEST_VERSION"
        if ! install_cloudflared; then
            log "Error: Failed to download and install cloudflared version $LATEST_VERSION."
            exit 1
        fi
    elif [ "$LOCAL_VERSION" != "$LATEST_VERSION" ]; then
        log "Updating cloudflared from version $CURRENT_VERSION to $LATEST_VERSION"
        if ! install_cloudflared; then
            log "Warning: Failed to download cloudflared version $LATEST_VERSION."
            log "Warning: Continuing with the existing binary, which may be out of date: $CLOUDFLARED_BIN (version: $CURRENT_VERSION)"
        fi
    else
        #use the local binary when it is already up to date
        log "Using existing cloudflared binary: $CLOUDFLARED_BIN (version: $LOCAL_VERSION)"
    fi
elif [ -x "$CLOUDFLARED_BIN" ]; then
    # Could not reach/parse the release metadata, but a binary is already installed
    log "Warning: Failed to fetch the latest cloudflared version; the current version may be out of date."
    log "Warning: Continuing with the existing binary: $CLOUDFLARED_BIN (version: $CURRENT_VERSION)"
else
    log "Error: Failed to fetch the latest cloudflared release metadata and no existing binary was found."
    exit 1
fi

# Start cloudflared
log "Starting cloudflared tunnel"
exec "$CLOUDFLARED_BIN" tunnel run --token "$TUNNEL_TOKEN"