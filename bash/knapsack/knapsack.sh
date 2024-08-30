#!/usr/bin/env bash
solve() {
	# Requires globals cap, best_v, weights values
	local -i i j w=0 v=0 min="$1" max="$2"
	local _start="" _end=""

	for ((i = 0; i < min; i++)); do _start="$_start"'1'; done
	for ((i = 0; i < max; i++)); do _end="$_end"'1'; done
	for ((i = 0; i < ${#weights[@]} - max; i++)); do _end="$_end"'0'; done

	((_start = 2#$_start, _end = 2#$_end))
	for ((i = _start; i < _end; i++)); do
		((w = 0, v = 0))
		for ((j = 0; j < ${#weights[@]}; j++)); do
			if (((2 ** j) & i)); then
				((w += weights[j], v += values[j]))
				if ((w > cap)); then break; fi
			fi
		done
		if ((w <= cap && v > best_v)); then ((best_v = v)); fi
	done
}

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi
	if (($# < 2)); then echo "0" && return; fi

	declare -ig cap="$1" best_v=0
	declare -ag weights values
	local i tmp max_items=0 min_items=0
	local -a weights_increasing

	for tmp in "${@:2}"; do
		values+=("${tmp#*:}")
		weights+=("${tmp%:*}")
	done

	readarray -t weights_increasing < <(for tmp in "${weights[@]}"; do echo "$tmp"; done | sort -n)
	if ((weights_increasing[0] > $1)); then echo "0" && return; fi

	((tmp = $1))
	for ((i = 0; i < ${#weights_increasing[@]}; i++)); do
		if ((weights_increasing[i] <= tmp)); then ((tmp -= weights_increasing[i], max_items++)); fi
	done
	((tmp = $1))
	for ((i = ${#weights_increasing[@]} - 1; i >= 0; i--)); do
		if ((weights_increasing[i] <= tmp)); then ((tmp -= weights_increasing[i], min_items++)); fi
	done

	solve "$min_items" "$max_items"
	echo "$best_v"
}

main "$@"
