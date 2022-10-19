#!/bin/sh
token=$(printenv token)

./cloudflared tunnel run --token $token