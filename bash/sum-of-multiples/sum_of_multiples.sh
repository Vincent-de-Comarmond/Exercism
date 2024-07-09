#!/usr/bin/env bash
main() {
	local -i level="$1" ep=0 item_level multiple stop i
	local -A multiples
	shift

	for item_level in "$@"; do
		(((item_level > 0) && (stop = level / item_level) || (stop = 0)))
		for ((i = 1; i <= stop; i++)); do
			((multiple = i * item_level))
			if [ "$multiple" -lt "$level" ]; then
				multiples["$multiple"]=1
			fi
		done
	done
	for multiple in "${!multiples[@]}"; do ((ep += multiple)); done
	echo "$ep"
}
main "$@"
