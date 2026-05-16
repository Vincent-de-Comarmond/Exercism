#!/usr/bin/env bash
main() {
	local -i a b c
	for ((a = 1; a <= ($1 - 3) / 3; a++)); do
		for ((b = a + 1; b <= ($1 - a) / 2; b++)); do
			((c = $1 - a - b))
			if ((a >= b || b >= c)); then continue; fi
			if ((a * a + b * b != c * c)); then continue; fi
			echo "$a,$b,$c"
		done
	done
}
main "$1"
