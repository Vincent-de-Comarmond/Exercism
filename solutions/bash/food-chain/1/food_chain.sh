#!/usr/bin/env bash
declare -a animals=("" fly spider bird cat dog goat cow horse)
declare -a seconds=("" "I don't know why she swallowed the fly. Perhaps she'll die."
	"It wriggled and jiggled and tickled inside her."
	"How absurd to swallow a bird!"
	"Imagine that, to swallow a cat!"
	"What a hog, to swallow a dog!"
	"Just opened her throat and swallowed a goat!"
	"I don't know how she swallowed a cow!"
	"She's dead, of course!")

die() { echo "$1" >/dev/stderr && exit 1; }

verse() {
	local j tmp
	echo -e "I know an old lady who swallowed a ${animals[$1]}.\n${seconds[$1]}"
	if (($1 == 1 || $i == 8)); then return; fi
	for ((j = $1; j > 1; j--)); do
		if ((j == 3)); then tmp=" ${seconds[2]/It/that}"; else tmp="."; fi
		echo "She swallowed the ${animals[$j]} to catch the ${animals[$j - 1]}$tmp"
	done
	echo "${seconds[1]}"
}

main() {
	local -i i
	if [ "$#" -ne 2 ]; then die "2 arguments expected"; fi
	if [ "$1" -gt "$2" ]; then die "Start must be less than or equal to End"; fi
	for ((i = $1; i <= $2; i++)); do
		verse "$i"
		if ((i < $2)); then echo ""; fi
	done
}

main "$@"
