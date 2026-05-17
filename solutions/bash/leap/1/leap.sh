#!/usr/bin/env bash
main() {
	if [[ ! "$*" =~ ^[0-9]+$ ]]; then
		echo "Usage: leap.sh <year>"
		exit 1
	fi

	local let mod4=$(($1 % 4))
	local let mod100=$(($1 % 100))
	local let mod400=$(($1 % 400))
	[[ $mod400 -eq 0 || ($mod100 -ne 0 && $mod4 -eq 0) ]] && echo "true" || echo "false"
}
main "$*"
