FROM alpine:latest
WORKDIR /home
RUN apk add --no-cache libc6-compat curl jq
COPY cloudflared.sh ./
RUN chmod +x ./cloudflared.sh
ENTRYPOINT ./cloudflared.sh
