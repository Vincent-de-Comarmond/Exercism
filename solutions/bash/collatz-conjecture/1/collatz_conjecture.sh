#!/usr/bin/env bash
main() {
	local -i steps=0 number="$1"
	if ((number <= 0)); then
		echo "Error: Only positive numbers are allowed" >/dev/stderr
		exit 1
	fi

	while ((number != 1)); do
		if ((number % 2 == 0)); then
			((number /= 2))
		else
			((number = 3 * number + 1))
		fi
		((steps++))
	done
	echo "$steps"
}
main "$1"
