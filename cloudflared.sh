#!/bin/sh
token=$(printenv token)
url=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | grep -w "browser_download_url.*cloudflared-linux-amd64" | head -1 | cut -d : -f 2,3 | tr -d \")
echo "Downloading latest cloudflared release..."
curl -L --output "cloudflared" $url
chmod +x ./cloudflared
./cloudflared tunnel run --token $token