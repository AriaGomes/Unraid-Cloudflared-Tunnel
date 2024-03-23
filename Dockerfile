FROM alpine:3.14

# Set working directory
WORKDIR /usr/src/app

# Install necessary packages
RUN apk add --no-cache curl jq

# Copy and set permissions for the script
COPY cloudflared.sh ./cloudflared.sh
RUN chmod +x ./cloudflared.sh

# Define entrypoint
ENTRYPOINT ["./cloudflared.sh"]
