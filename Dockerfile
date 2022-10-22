FROM alpine:latest
WORKDIR /home
RUN apk add --no-cache curl
RUN apk add --no-cache libc6-compat
COPY cloudflared.sh ./
RUN chmod +x ./cloudflared.sh
ENTRYPOINT ./cloudflared.sh
