#!/usr/bin/env bash
main() {
	local cleaned="${*^^}" duplicate_letter_count
	cleaned="${cleaned// /}"
	cleaned="${cleaned//-/}"
	duplicate_letter_count=$(echo "$cleaned" | grep -o . | sort | uniq -d | wc -l)
	if [ "$duplicate_letter_count" -eq 0 ]; then
		echo "true"
	else
		echo "false"
	fi
}
main "$*"
