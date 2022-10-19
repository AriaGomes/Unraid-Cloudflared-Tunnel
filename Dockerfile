FROM alpine:latest
WORKDIR /home
RUN apk add --no-cache curl
RUN curl -L --output cloudflared https://github.com/cloudflare/cloudflared/releases/download/2022.10.2/cloudflared-linux-amd64
RUN apk add libc6-compat
COPY cloudflared.sh ./
RUN chmod +x ./cloudflared.sh
RUN chmod +x ./cloudflared
ENTRYPOINT ./cloudflared.sh
