#!/usr/bin/env bash
print_arr() {
	local -n _printme="$1"
	local _key
	for _key in "${!_printme[@]}"; do echo "$_key ${_printme[$_key]}"; done
}

resort_arr() {
	local idx
	local -n _sortme="$1" _sortby="$2"
	local -a _tmp=()
	readarray -t _tmp < <(for idx in "${_sortby[@]}"; do echo "${_sortme[$idx]}"; done)
	echo "${_tmp[@]}"
}

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi

	local i _str val wgt den capacity="$1" score=0
	local -a wv_str weights values density sorted_idx

	read -r -a wv_str < <(tr ":" " " <<<"${@:2}")
	for ((i = 0; i < ${#wv_str[@]}; i += 2)); do
		wgt="${wv_str[$i]}"
		val="${wv_str[$i + 1]}"
		read -r den < <(bc -l <<<"$val/$wgt")
		weights+=("$wgt")
		values+=("$val")
		density+=("$den")
	done

	readarray -t sorted_idx < <(print_arr density | sort -g -k2 -r | cut -d " " -f1)
	read -r -a weights < <(resort_arr weights sorted_idx)
	read -r -a values < <(resort_arr values sorted_idx)
	read -r -a density < <(resort_arr density sorted_idx)

	for ((i = 0; i < ${#values[@]}; i++)); do
		if ((weights[i] <= capacity)); then
			((score += values[i]))
			((capacity -= weights[i]))
		fi
	done
	echo "$score"
}

main "$@"
