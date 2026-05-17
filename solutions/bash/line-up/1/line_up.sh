#!/usr/bin/env bash

print_greeting() {
	echo "$1, you are the $2$3 customer we serve today. Thank you!"
}

main() {
	local name="$1" number="$2" length="${#2}"
	local suffix="th"
	if ((length == 1)); then
		case "$number" in
		1) suffix="st" ;;
		2) suffix="nd" ;;
		3) suffix="rd" ;;
		esac
		print_greeting "$name" "$number" "$suffix"
	else
		let "length-=1"
		local last="${number:length:1}"
		let "length-=1"
		local last_2nd="${number:length:1}"

		if [[ "$last" == "1" && "$last_2nd" != "1" ]]; then
			suffix="st"
		elif [[ "$last" == "2" && "$last_2nd" != "1" ]]; then
			suffix="nd"
		elif [[ "$last" == "3" && "$last_2nd" != "1" ]]; then
			suffix="rd"
		fi
		print_greeting "$name" "$number" "$suffix"
	fi
}

main "$@"
