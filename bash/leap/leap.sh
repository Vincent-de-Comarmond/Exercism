#!/usr/bin/env bash
main() {
	if [[ ! "$*" =~ ^[0-9]+$ ]]; then
		echo "Usage: leap.sh <year>"
		exit 1
	fi
	local mod4 mod100 mod400
	((mod4 = $1 % 4))
	((mod100 = $1 % 100))
	((mod400 = $1 % 400))
	[[ $mod400 -eq 0 || ($mod100 -ne 0 && $mod4 -eq 0) ]] && echo "true" || echo "false"
}
main "$*"
