#!/usr/bin/env bash
main() {
	local input="$1" output="" i j
	local -a vals=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
	local -a chars=(M CM D CD C XC L XL X IX V IV I)

	for ((i = 0; i < ${#vals[@]}; i++)); do
		for ((j = 0; j < input / vals[i]; j++)); do output="$output${chars[$i]}"; done
		((input -= j * vals[i]))
	done
	echo "$output"
}

main "$1"
