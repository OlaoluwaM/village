#!/usr/bin/env bash

# This script allows us run sqitch in a docker container, so we don't have to install it on our local machine.

docker run -it --rm --network host \
	-v "$(pwd)/db/sqitch:/repo" \
	-u "$(id -u ${USER}):$(id -g ${USER})" \
	"${passopt[@]}" sqitch/sqitch "$@"
