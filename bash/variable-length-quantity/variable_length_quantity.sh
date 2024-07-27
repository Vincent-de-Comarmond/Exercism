#!/usr/bin/env bash
declare -A _hex2bin=(
	[0]=0000 [1]=0001 [2]=0010 [3]=0011 [4]=0100 [5]=0101 [6]=0110 [7]=0111
	[8]=1000 [9]=1001 [A]=1010 [B]=1011 [C]=1100 [D]=1101 [E]=1110 [F]=1111
)
declare -A _bin2hex=(
	[0000]=0 [0001]=1 [0010]=2 [0011]=3 [0100]=4 [0101]=5 [0110]=6 [0111]=7
	[1000]=8 [1001]=9 [1010]=A [1011]=B [1100]=C [1101]=D [1110]=E [1111]=F
)

die() { echo "$1" >/dev/stderr && exit 1; }

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

_enc() {
	local i val
	local -a bitarray
	read -r val < <(hex2bin "$1")
	read -r -a bitarray < <(split "$val" 7) && val=""
	printf -v bitarray[0] "%07d" "${bitarray[0]}"

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
}

encode() {
	local single output
	for single in "$@"; do output="$output""$(_enc "$single")"; done
	split "$output" 2
}

decode() {
	local bits tmp tmp2 in="${*// /}" idx=0
	local -a bitarray combined outarray=()
	read -r bits < <(hex2bin "$in")
	read -r -a bitarray < <(split "$bits" 8)

	for bits in "${bitarray[@]}"; do
		combined["$idx"]="${combined[$idx]}""${bits:1}"
		if [ "${bits:0:1}" -eq 0 ]; then ((idx++)); fi
	done
	if [ "${bits:0:1}" -ne 0 ]; then die "incomplete byte sequence"; fi

	idx=0
	for bits in "${combined[@]}"; do
		bitarray=()
		read -r -a bitarray < <(split "$bits" 4)
		for tmp in "${bitarray[@]}"; do
			printf -v tmp2 "%04.f" "$tmp" # Headache of convenience
			outarray["$idx"]="${outarray[$idx]}""${_bin2hex[$tmp2]}"
		done
		printf -v outarray["$idx"] "%02x" "0x${outarray[$idx]}" # manage leading 0s
		outarray["$idx"]="${outarray[$idx]^^}"                  # Upcase
		((idx++))
	done
	echo "${outarray[@]}"
}

main() {
	if [[ "$1" != "encode" && "$1" != "decode" ]]; then die "unknown subcommand"; fi
	"$1" "${@:2}"
}

main "$@"
