#!/usr/bin/env bash

main() {
	declare -A points
	points["[AEIOULNRST]"]=1
	points["[DG]"]=2
	points["[BCMP]"]=3
	points["[FHVWY]"]=4
	points["K"]=5
	points["[JX]"]=8
	points["[QZ]"]=10

	score=0
	while read -r -n1 char; do
		for key in "${!points[@]}"; do
			if [[ "$char" =~ $key ]]; then
				((score += points[$key]))
				break
			fi
		done
	done <<<"${1^^}"
	echo $score
}
main "$1"
