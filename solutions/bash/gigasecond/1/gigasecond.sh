#!/usr/bin/env bash
main() {
	local -i time
	time=$(date "+%s" -d "$1")
	((time += 1000000000))
	printf "%(%Y-%m-%dT%H:%M:%S)T\n" "$time"
}
main "$1"
