#!/usr/bin/env bash
main() {
	local current=2 remaining="$1"
	local -a factors

	while ((remaining != 1)); do
		if ((remaining % current == 0)); then
			((remaining /= current))
			factors+=("$current")
		else
			((current == 2)) && ((current = 3)) || ((current += 2))
		fi
	done
	echo "${factors[@]}"
}
main "$1"
