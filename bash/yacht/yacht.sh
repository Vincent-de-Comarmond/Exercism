#!/usr/bin/env bash
filter_score() {
	local -i num filter="$1" score=0
	for num in "${@:2}"; do ((score = num == filter ? score + num : score)); done
	echo "$score"
}

sort_dice() {
	tr ' ' '\n' <<<"$@" | sort | paste -s -d ' '
}

sum_dice() {
	local -i i total
	for i in "$@"; do ((total += i)); done
	echo "$total"
}

full_house() {
	local -i score=0
	if [[ "$1" == "$2" && "$4" == "$5" && "$1" != "$5" ]]; then
		if [[ "$2" == "$3" || "$3" == "$4" ]]; then score="$(sum_dice "$@")"; fi
	fi
	echo "$score"
}

four_of_a_kind() {
	local -i score=0
	if [[ "$2$3$4" == "$2$2$2" ]]; then
		((score = $2 == $1 ? 4 * $1 : score))
		((score = $2 == $5 ? 4 * $5 : score))
	fi
	echo "$score"
}

bstraight() { if [ "$*" == "2 3 4 5 6" ]; then echo 30; else echo 0; fi; }
lstraight() { if [ "$*" == "1 2 3 4 5" ]; then echo 30; else echo 0; fi; }
yacht() { if [[ "$1$1$1$1" == "$2$3$4$5" ]]; then echo 50; else echo 0; fi; }

main() {
	local -a sorted
	local -A simple_lookup=([ones]=1 [twos]=2 [threes]=3 [fours]=4 [fives]=5 [sixes]=6)

	if test -v "${simple_lookup[$1]}"; then
		filter_score "${simple_lookup[$1]}" "${@:2}"
		return
	fi

	sorted=($(sort_dice "${@:2}"))

	case "$1" in
	"choice") sum_dice "${sorted[@]}" ;;
	"full house") full_house "${sorted[@]}" ;;
	"four of a kind") four_of_a_kind "${sorted[@]}" ;;
	"little straight") lstraight "${sorted[@]}" ;;
	"big straight") bstraight "${sorted[@]}" ;;
	"yacht") yacht "${sorted[@]}" ;;
	esac
}
main "$@"
