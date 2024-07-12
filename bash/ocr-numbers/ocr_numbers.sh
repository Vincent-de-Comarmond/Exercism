#!/usr/bin/env bash
declare -a lines
die() {
	echo "$1" >/dev/stderr
	exit 1
}

read_input() {
	while IFS= read -r line; do
		((columns = ${#line}))
		if [ "$line" != "" ]; then lines+=("$line"); fi
		if ((columns % 3 != 0)); then die "Number of input columns is not a multiple of three"; fi
	done <"${1:-/dev/stdin}"

	((rows = ${#lines[@]}))
	if ((rows % 4 != 0)); then die "Number of input lines is not a multiple of four"; fi

}

read_next() {
	local -i line_idx="${1:-0}" char_idx="${2:-0}" i j
	local input="" output

	for ((j = line_idx; j < line_idx + 4; j++)); do
		for ((i = char_idx; i < char_idx + 3; i++)); do
			input="$input${lines[$j]:$i:1}"
		done
	done
	case "$input" in
	" _ | ||_|   ") output=0 ;;
	"     |  |   ") output=1 ;;
	" _  _||_    ") output=2 ;;
	" _  _| _|   ") output=3 ;;
	"   |_|  |   ") output=4 ;;
	" _ |_  _|   ") output=5 ;;
	" _ |_ |_|   ") output=6 ;;
	" _   |  |   ") output=7 ;;
	" _ |_||_|   ") output=8 ;;
	" _ |_| _|   ") output=9 ;;
	*) output="?" ;;
	esac
	printf "$output"
}

main() {
	local -i rows=0 columns=0 i j
	if test -t 0; then
		# Arguments are strings on /dev/stdin. Alternatively script is connected to a temporary fd created by the heredoc
		if [ "${#1}" -eq 0 ]; then echo "" && exit 0; fi
	fi
	read_input "$*"

	for ((i = 0; i < rows; i += 4)); do
		if ((i > 0)); then printf ","; fi
		for ((j = 0; j < columns; j += 3)); do
			read_next "$i" "$j"
		done
	done
}
main "$*"
