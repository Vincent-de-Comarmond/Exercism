#!/usr/bin/env bash
validate() {
	[ "$1" -lt 0 ] && echo "row not positive" >/dev/stderr && exit 1
	[ "$2" -lt 0 ] && echo "column not positive" >/dev/stderr && exit 1
	[ "$1" -ge 8 ] && echo "row not on board" >/dev/stderr && exit 1
	[ "$2" -ge 8 ] && echo "column not on board" >/dev/stderr && exit 1
}

aligned() {
	(($1 == $3)) && (($2 == $4)) && echo "same position" >/dev/stderr && exit 1
	if (($3 - $1 == 0)) || (($4 - $2 == 0)); then
		echo "true" && return
	fi
	if (($3 - $1 == $4 - $2)) || (($3 - $1 == $2 - $4)); then
		echo "true" && return
	fi
	echo "false"
}

main() {
	local w_ij b_ij
	local -i w_i w_j b_i b_j
	while test "$#" -gt 0; do
		case "$1" in
		"-w") shift && w_ij="$1" ;;
		"-b") shift && b_ij="$1" ;;
		esac
		shift
	done
	IFS="," read -r w_i w_j <<<"$w_ij"
	IFS="," read -r b_i b_j <<<"$b_ij"
	validate "$w_i" "$w_j"
	validate "$b_i" "$b_j"
	aligned "$w_i" "$w_j" "$b_i" "$b_j"
}

main "$@"
