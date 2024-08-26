#!/usr/bin/env bash
print_arr() {
	local -n _printme="$1"
	local _key
	for _key in "${!_printme[@]}"; do echo -e "$_key)\t${_printme[$_key]}"; done
}

arr_max() {
	local -i __tmp _max=-1000000
	for __tmp in "$@"; do ((_max = __tmp > _max ? __tmp : _max)); done
	echo "$_max"
}

copy_omit() {
	local -n cpy="$1"
	local -a tmp=()
	local -i _idx omit="$2"
	for _idx in "${!cpy[@]}"; do if ((_idx != omit)); then tmp+=("${cpy[$_idx]}"); fi; done
	echo "${tmp[*]}"
}

pack_bag() {
	local -i i j _c weight val modified=0
	local -a w v c s

	read -r -a w <<<"${weights[0]}"

	for ((_c = 0; _c < ${#w[@]} + 1; _c++)); do
		for i in "${!weights[@]}"; do
			read -r -a w <<<"${weights[$i]}"
			read -r -a v <<<"${values[$i]}"
			read -r -a c <<<"${capacities[$i]}"
			read -r -a s <<<"${scores[$i]}"

			modified=0
			for j in "${!w[@]}"; do
				weight="${w[$j]}"
				val="${v[$j]}"
				if ((weight <= c)); then
					modified=1
					scores+=($((s + val)))
					capacities+=($((c - weight)))
					weights+=("$(copy_omit w "$j")")
					values+=("$(copy_omit v "$j")")
				fi
			done
			if ((modified == 1)); then
				unset weights["$i"]
				unset values["$i"]
				unset capacities["$i"]
				unset scores["$i"]
			fi
		done
	done
}

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi

	local -i idx
	local -a w__v tmp_w tmp_v
	local w_str v_str

	read -r -a w__v < <(tr ":" " " <<<"${@:2}")
	for ((idx = 0; idx < ${#w__v[@]}; idx += 2)); do
		tmp_w+=("${w__v[$idx]}")
		tmp_v+=("${w__v[$idx + 1]}")
	done

	w_str="${tmp_w[*]}"
	v_str="${tmp_v[*]}"
	declare -ag weights=("$w_str") values=("$v_str") capacities=("$1") scores=(0)
	pack_bag
	arr_max "${scores[@]}"
}

main "$@"
