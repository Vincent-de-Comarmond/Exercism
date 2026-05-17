#!/usr/bin/env bash
main() {
	declare -A actions
	local i result
	actions[1]="wink"
	actions[2]="double blink"
	actions[4]="close your eyes"
	actions[8]="jump"

	for i in 1 2 4 8; do
		(($1 & i)) && (($1 & 16)) && result="${actions[$i]}","$result"
		(($1 & i)) && ! (($1 & 16)) && result="$result","${actions[$i]}"
	done
	result="${result#,}"
	echo "${result%,}"
}
main "$1"
