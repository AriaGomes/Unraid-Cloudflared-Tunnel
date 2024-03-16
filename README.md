# Unraid Cloudflared Tunnel

A simple way to get a Cloudflared tunnel on Unraid.


Only Supportting amd64. If you need other architechure start an issue or feel free to build from source :)

[![Video](https://img.youtube.com/vi/h5fAcE70xbQ/0.jpg)](https://www.youtube.com/watch?v=h5fAcE70xbQ)

*Thanks to SpaceInvader One and the Unraid Team*

## Environment Variables
For more information on these variables visit the Cloudflared docs [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/)

### Required
`TUNNEL_TOKEN` or `token` - Your cloudflared tunnel token. Associates the cloudflared instance with a specific tunnel. The tunnel’s token is shown in the dashboard when you first create the tunnel. You can also retrieve the token using the API. (`TUNNEL_TOKEN` should be used over `token` going forward)

### Optional
`TUNNEL_EDGE_BIND_ADDRESS` - Specifies the outgoing IP address used to establish a connection between cloudflared and the Cloudflare global network. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#edge-bind-address)

`TUNNEL_EDGE_IP_VERSION` - Specifies the IP address version (IPv4 or IPv6) used to establish a connection between cloudflared and the Cloudflare global network. Available values are auto, 4, and 6. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#edge-ip-version)

`TUNNEL_GRACE_PERIOD` - When cloudflared receives SIGINT/SIGTERM it will stop accepting new requests, wait for in-progress requests to terminate, then shut down. Waiting for in-progress requests will timeout after this grace period, or when a second SIGTERM/SIGINT is received. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#grace-period)

`TUNNEL_LOGFILE` - Saves application log to this file. Mainly useful for reporting issues. For more details on what information you need when contacting Cloudflare support. (You will need to add a volume or use the console to access this logfile) [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#logfile)

`TUNNEL_LOGLEVEL` - Specifies the verbosity of logging. The default info level does not produce much output, but you may wish to use the warn level in production. Available values are: debug, info, warn, error, fatal. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#loglevel)

`TUNNEL_METRICS` - Exposes a Prometheus endpoint on the specified IP address/port, which you can then query for usage metrics. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#metrics)

`NO_AUTOUPDATE` - Disables automatic cloudflared updates. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#no-autoupdate)

`TUNNEL_ORIGIN_CERT` - Specifies the account certificate for one of your zones, authorizing the client to serve as an origin for that zone. You can obtain a certificate by using the cloudflared tunnel login command or by visiting https://dash.cloudflare.com/argotunnel. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#origincert)

`TUNNEL_PIDFILE` - Writes the application’s process identifier (PID) to this file after the first successful connection. Mainly useful for scripting and service integration. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#pidfile)

`TUNNEL_TRANSPORT_PROTOCOL` - Specifies the protocol used to establish a connection between cloudflared and the Cloudflare global network. Available values are auto, http2, and quic. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#protocol)

`TUNNEL_REGION` - Allows you to choose the regions to which connections are established. Currently the only available value is us, which routes all connections through data centers in the United States. Omit or leave empty to connect to the global region. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#region)

`TUNNEL_RETRIES` - Specifies the maximum number of retries for connection/protocol errors. Retries use exponential backoff (retrying at 1, 2, 4, 8, 16 seconds by default), so it is not recommended that you increase this value significantly. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#retries)

`TUNNEL_TAG` - Specifies custom tags used to identify this tunnel. Multiple tags may be specified by adding additional `--tag <KEY=VAL>` flags to the command. If entering multiple tags into a configuration file, delimit with commas: tag: {KEY1=VALUE1, KEY2=VALUE2}. [More Info](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/tunnel-run-parameters/#tag)

