#!/usr/bin/env bash
left() { echo "$1" $(($2 + 1)); }
down() { echo $(($1 + 1)) "$2"; }
right() { echo "$1" $(($2 - 1)); }
up() { echo $(($1 - 1)) "$2"; }

main() {
	local -i s="$1" r=0 c=0 d=0 i idx tr tc
	local -a directions=("left" "down" "right" "up") sp_matrix
	local -A matrix=([0]=1)

	for ((i = 1; i < s * s; i++)); do
		read -r tr tc < <("${directions[$d]}" "$r" "$c")
		((idx = s * tr + tc))
		if test -v matrix["$idx"] || ((tr < 0 || tc < 0 || s <= tr || s <= tc)); then
			((d = (d + 1) % 4, i--))
		else
			((c = tc, r = tr))
			matrix["$idx"]=$((i + 1))
		fi
	done

	for ((i = 0; i < s * s; i++)); do sp_matrix["$i"]="${matrix[$i]}"; done
	for ((i = 0; i < s * s; i += s)); do echo "${sp_matrix[@]:$i:$s}"; done
}
main "$@"
