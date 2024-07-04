#!/usr/bin/env bash
shopt -s extglob
# For dynamic regex matching
# shellcheck disable=SC2254  
main() {
	local pattern="^\+?1?-?[2-9][0-9]{2}-?[2-9][0-9]{2}-?[0-9]{4}$"
	local cleaned="${1%%+( )}"      # Strip trailing whitespace
	cleaned="${cleaned##+( )}"      # Strip leading whitespace
	cleaned="${cleaned//+( )/-}"    # Replace multiple whitespace with hyphen
	cleaned="${cleaned//[^0-9+-]/}" # Reduce to character set
	if [[ "$cleaned" =~ $pattern ]]; then
		cleaned="${cleaned//[^0-9]/}"
		echo "${cleaned: -10}"
	else
		echo "Invalid number.  [1]NXX-NXX-XXXX N=2-9, X=0-9" >/dev/stderr
		exit 1
	fi
}
main "$*"
