FROM alpine:3.14

# Set working directory
WORKDIR /usr/src/app

# Install necessary packages
RUN apk add --no-cache curl jq

# Download and install cloudflared
RUN url=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | jq -r '.assets[] | select(.browser_download_url | endswith("cloudflared-linux-amd64")) | .browser_download_url') && \
    curl -L --output "cloudflared" $url && \
    chmod +x ./cloudflared && \
    mv ./cloudflared /usr/local/bin/

# Copy and set permissions for the script
COPY cloudflared.sh ./cloudflared.sh
RUN chmod +x ./cloudflared.sh

# Define entrypoint
ENTRYPOINT ["./cloudflared.sh"]
