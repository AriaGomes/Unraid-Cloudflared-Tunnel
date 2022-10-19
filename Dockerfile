FROM debian:latest
WORKDIR /home
RUN apt-get update && apt-get install -y curl
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
RUN dpkg -i cloudflared.deb

COPY cloudflared.sh ./
RUN chmod +x ./cloudflared.sh
ENTRYPOINT ./cloudflared.sh
