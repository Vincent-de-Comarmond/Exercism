#!/usr/bin/env bash
declare -A _hex2bin=(
	[0]=0000 [1]=0001 [2]=0010 [3]=0011 [4]=0100 [5]=0101 [6]=0110 [7]=0111
	[8]=1000 [9]=1001 [A]=1010 [B]=1011 [C]=1100 [D]=1101 [E]=1110 [F]=1111
)
declare -A _bin2hex=(
	[0000]=0 [0001]=1 [0010]=2 [0011]=3 [0100]=4 [0101]=5 [0110]=6 [0111]=7
	[1000]=8 [1001]=9 [1010]=A [1011]=B [1100]=C [1101]=D [1110]=E [1111]=F
)

hex2bin() {
	local i out
	for ((i = 0; i < ${#1}; i++)); do out="$out${_hex2bin[${1:$i:1}]}"; done
	echo "$out"
}

split() {
	local i start out=""
	for ((i = ${#1}; i >= 0; i -= $2)); do
		((start = i >= $2 ? i - $2 : 0))
		out="${1:$start:$i-$start} ${out% }"
	done
	echo "${out# }"
}

enc() {
	local i val
	local -a bitarray
	read -r val < <(hex2bin "$1")
	read -r -a bitarray < <(split "$val" 7) && val=""
	printf -v bitarray[0] "%07d" "${bitarray[0]}"

	# echo "${bitarray[@]}"
	for ((i = 0; i < ${#bitarray[@]}; i++)); do
		if [ "$val" != "" ] || ((bitarray[i] != 0)); then
			if ((i == ${#bitarray[@]} - 1)); then
				val="$val"0"${bitarray[$i]}"
			else
				val="$val"1"${bitarray[$i]}"
			fi
		fi
	done
	read -r -a bitarray < <(split "$val" 4) && val=""
	for i in "${bitarray[@]}"; do
		if [[ "$val" != "" || "${_bin2hex[$i]}" != 0 ]]; then
			val="$val${_bin2hex[$i]}"
		fi
	done

	echo "${val:-00}"
	# split "${val:-00}" 2
}

encode() {
	local single output
	for single in "$@"; do
		output="$output""$(enc "$single")"
	done

	split "$output" 2
}

decode() {
	:
}

# hex2bin "$1"
# split "$1" "$2"
"$1" "${@:2}"
