#!/usr/bin/env bash
readlines() {
	local -n line_array="$1"
	while IFS= read -r line; do
		line_array+=("$line")
	done >&0
}

transpose_array() {
	local -n array1="$1" array2="$2"
	local col tmp row
	for ((col = 0; col < ${#array1[0]}; col++)); do
		tmp=""
		for row in "${array1[@]}"; do
			tmp="$tmp${row:$col:1}"
		done
		array2["$col"]="$tmp"
	done
}

get_horiz() {
	while read -r line; do
		[ "$line" == "" ] && continue
		echo "${line%%:*}"
	done < <(grep -bo '+' <<<"$1") | paste -s -d ' '
}

get_valid_pairs() {
	local -a array
	local -i i j start length
	local substring
	# Get corners
	read -a array < <(grep -bo '+' <<<"$1" | cut -d: -f1 | paste -s)
	for ((i = 0; i < ${#array[@]} - 1; i++)); do
		for ((j = i + 1; j < ${#array[@]}; j++)); do
			((start = ${array[i]}))
			((length = ${array[j]} - start + 1))
			substring="${1:start:length}"
			if [[ "$substring" =~ ^(\+|\-)*$ ]]; then
				echo "$substring" | tr "+" "-"
			fi
		done
	done
}

print_array() {
	local -n array="$1"
	echo ""
	for row in "${array[@]}"; do
		echo "$row"
	done

}

main() {
	local -a horiz verts
	local -i i j
	local line1 line2
	readlines horiz
	transpose_array horiz verts

	for ((i = 0; i < ${#horiz[@]} - 1; i++)); do
	    line1="${horiz[$i]}"
		for ((j = i + 1; j < ${#horiz[@]}; j++)); do

		done
	done

	local idx=0
	for line in "${horiz[@]}"; do
		echo "Line number: $idx"
		get_valid_pairs "$line"
		((idx++))
	done
	# for line in "${verts[@]}"; do
	# 	get_horiz "$line"
	# done

	# print_array horiz
	# print_array verts

}

main "$@"
