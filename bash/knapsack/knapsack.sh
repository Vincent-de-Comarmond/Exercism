#!/usr/bin/env bash
choices() {
	local -i i j tot n_symb="$1" min="$2" max="$3"
	local -a vec
	for ((i = 1; i < 2 ** n_symb; i++)); do
		tot=0
		vec=()
		for ((j = 0; j < n_symb; j++)); do ((k = ((2 ** j) & i) > 0, tot += k, vec[${#vec[@]}] = k)); done
		if ((min <= tot && tot <= max)); then echo "${vec[@]}"; fi
	done
}

sum_v() {
	local -i w="$1" v=0 i idx=0
	for i in "${@:2}"; do
		if ((i == 1)); then
			((w -= weights[idx], v += values[idx]))
			if ((w < 0)); then ((v = -1)) && break; fi
		fi
		((idx++))
	done
	echo "$v"
}

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi

	local cap="$1" tmp1="$1" tmp2="$1"
	local i _str maxi=0 mini=0
	local -a w_incr choice_array
	declare -ag weights values

	for _str in "${@:2}"; do
		values+=("${_str#*:}")
		weights+=("${_str%:*}")
	done

	readarray -t w_incr < <(for _str in "${weights[@]}"; do echo "$_str"; done | sort -n)
	for i in "${!weights[@]}"; do
		((_str = ${#w_incr[@]} - 1 - i))
		if ((w_incr[i] <= tmp1)); then ((tmp1 -= w_incr[i], maxi++)); fi
		if ((w_incr[_str] <= tmp2)); then ((tmp2 -= w_incr[_str], mini++)); fi
	done

	tmp2=0
	readarray -t choice_array < <(choices "${#weights[@]}" "$mini" "$maxi")
	for _str in "${choice_array[@]}"; do
		read -r tmp1 < <(sum_v "$cap" $_str) # intentional string splitting
		((tmp2 = tmp1 > tmp2 ? tmp1 : tmp2))
	done
	echo "$tmp2"
}

main "$@"
