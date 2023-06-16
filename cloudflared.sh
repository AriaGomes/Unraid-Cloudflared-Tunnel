#!/bin/sh
echo "Downloading latest cloudflared release..."
token=$(printenv token)
url=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | jq -r '.assets[] | select(.browser_download_url | endswith("cloudflared-linux-amd64")) | .browser_download_url')
curl -L --output "cloudflared" $url
chmod +x ./cloudflared
./cloudflared tunnel run --token $token --no-autoupdate
