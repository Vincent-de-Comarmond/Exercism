#!/usr/bin/env bash
main() {
	local -a plants students_plants
	readarray -t -d $'\n' plants <<<"$1"
	local -A plant_types=([C]=clover [G]=grass [R]=radishes [V]=violets)
	local -i idx
	idx=$(expr index ABCDEFGHIJKLMNOPQRSTUVWXYZ "$2:1:1")
	((idx = 2 * idx - 2))

	for line in "${plants[@]}"; do
		students_plants+=("${plant_types[${line:$idx:1}]}" "${plant_types[${line:$idx+1:1}]}")
	done
	echo "${students_plants[@]}"
}

main "$@"
