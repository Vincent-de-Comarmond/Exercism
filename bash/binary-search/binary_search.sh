#!/usr/bin/env bash
main() {
	local -a array=("${@:2}")
	local -i idx val offset=0

	while ((${#array[@]} > 0)); do
		((idx = ${#array[@]} / 2))
		((val = $1 - array[idx]))
		if [ "${#array[@]}" -eq 1 ] && [ "$val" -ne 0 ]; then break; fi
		case "$val" in
		0) echo $((offset + idx)) && return ;;
		-[1-9]*) array=("${array[@]:0:$idx}") ;;
		*)
			array=("${array[@]:$idx}")
			((offset += idx))
			;;
		esac
	done
	echo "-1"
}

main "$@"
