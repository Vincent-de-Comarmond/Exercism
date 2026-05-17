#!/usr/bin/env bash

main() {
	if [[ "$1" -le 1 || "$3" -le 1 ]]; then
		echo "Impossible base" >/dev/stderr
		exit 1
	fi

	if [ "$1" -eq "$3" ]; then
		echo "$2"
		return
	fi

	local -i i power base10=0
	local -a conv_arr result
	read -r -a conv_arr <<<"$2"

	for ((i = 0; i < ${#conv_arr[@]}; i++)); do
		if ((conv_arr[i] < 0 || conv_arr[i] >= $1)); then
			echo "Invalid digit" >/dev/stderr
			exit 1
		fi
		((power = $1 ** (${#conv_arr[@]} - 1 - i)))
		((base10 += ${conv_arr[i]} * power))
	done

	if [ "$base10" -eq 0 ]; then
		echo 0
		return
	fi

	i=0
	conv_arr=()
	while [ "$base10" -gt 0 ]; do
		((conv_arr[i] = base10 % $3))
		((base10 = base10 / $3))
		((i++))
	done

	for ((i = ${#conv_arr[@]} - 1; i >= 0; i--)); do result+=("${conv_arr[$i]}"); done
	echo "${result[@]}"
}

main "$@"
