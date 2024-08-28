#!/usr/bin/env bash
print_arr() {
	local -n _printme="$1"
	local _key
	for _key in "${!_printme[@]}"; do echo "$_key ${_printme[$_key]}"; done
}

# choose() {
# 	local -i i n="$1" r="$2"
# 	local _str=""
# 	local -a tmp choice_ensemble choices

# 	read -r -a tmp < <(for ((i = 0; i < n; i++)); do echo "$i"; done)

# 	for ((i = 0; i < r; i++)); do
# 	done
# }

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi

	declare -Ag choice_cache=()
	local i _str tmp1 tmp2 min_item=0 max_item=0 capacity="$1" score=0
	local -a wv_str weights values weights_incr weights_decr

	read -r -a wv_str < <(tr ":" " " <<<"${@:2}")
	for ((i = 0; i < ${#wv_str[@]}; i += 2)); do
		weights+=("${wv_str[$i]}")
		values+=("${wv_str[$i + 1]}")
	done

	readarray -t weights_incr < <(for _str in "${weights[@]}"; do echo "$_str"; done | sort -n)
	readarray -t weights_decr < <(for _str in "${weights[@]}"; do echo "$_str"; done | sort -n -r)

	((tmp1 = capacity, tmp2 = capacity))
	for i in "${!weights[@]}"; do
		if ((weights_incr[i] <= tmp1)); then ((tmp1 -= weights_incr[i], max_item++)); fi
		if ((weights_decr[i] <= tmp2)); then ((tmp2 -= weights_decr[i], min_item++)); fi
	done

	echo "Max items: $max_item"
	echo "Min items: $min_item"

}

# main "$@"

# declare -a array
# choose 5 2 array

declare -a array
readarray -t array < <(for ((i = 0; i < 15; i++)); do echo "$i"; done)
echo "${array[@]}"

heaps() {
	local -i i a b idx
	local -a A=("${@:2}")
	if (($1 == 1)); then
		echo "${A[@]}"
	else
		heaps $(($1 - 1)) "${A[@]}"
		for ((i = 0; i < $1 - 1; i++)); do
			((idx = $1 % 2 == 0 ? i : 0))
			((a = A[idx]))
			((b = A[$1 - 1]))
			A["$idx"]="$b"
			A["$(($1 - 1))"]="$a"
			heaps $(($1 - 1)) "${A[@]}"
		done
	fi
}

heaps "${#array[@]}" "${array[@]}"
