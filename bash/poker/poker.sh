#!/usr/bin/env bash

#########
# Hands #
#########
# Five of a kind   # we don't have
# Straight flush        8
# Four of a kind	7
# Full house		6
# Flush		5
# Straight		4
# Three of a kind	3
# Two pair		2
# One pair		1
# High card		0

map_hand() {
	echo "$1" | sed -E -e 's/(\w+)/0\1/g' -e 's/A/1/g' -e 's/J/11/g' -e 's/Q/12/g' -e 's/K/13/g' -e 's/0([0-9][0-9])/\1/g' | tr " " "\n" | sort | tr "\n" " "
	echo ""
}

minimax() {
	local arg min=1000 max=-1000
	for arg in "$@"; do
		if ((arg <= min)); then min="$arg"; fi
		if ((arg >= max)); then max="$arg"; fi
	done
	echo "$min $max"
}

score_hand() {
	local arg min max tmp idx
	local -a hand suites numbers numbers2
	local -A counts

	read -r -a hand <<<"$1"
	readarray -t suites < <(for arg in "${hand[@]}"; do echo "${arg:${#arg}-1}"; done | uniq)
	readarray -t numbers < <(for arg in "${hand[@]}"; do echo "${arg:0:-1}"; done)
	read -r min max < <(minimax "${numbers[@]}")

	for arg in "${numbers[@]}"; do numbers2+=("$((arg - min))"); done # reduced numbers
	read -r tmp < <(echo {0..4})
	for arg in "${numbers[@]}"; do ((counts[$arg]++)); done

	##################
	# Straight Flush #
	##################
	if [[ "${#suites[@]}" -eq 1 && "${numbers2[*]}" == "$tmp" ]]; then
		echo "8 $((max))" && return
	fi
	##################
	# Four of a kind #
	##################
	if [[ "${counts[*]}" == "1 4" || "${counts[*]}" == "4 1" ]]; then
		for tmp in "${!counts[@]}"; do
			if [ "${counts[$tmp]}" -eq 1 ]; then min="$tmp" && continue; fi
			max="$tmp"
		done
		echo "7 $((max)) $((min))" && return
	fi
	##############
	# Full House #
	##############
	if [[ "${counts[*]}" == "2 3" || "${counts[*]}" == "3 2" ]]; then
		for tmp in "${!counts[@]}"; do
			if [ "${counts[$tmp]}" -eq 2 ]; then min="$tmp" && continue; fi
			max="$tmp"
		done
		echo "6 $((max)) $((min))" && return
	fi
	#########
	# Flush #
	#########
	if ((${#suites[@]} == 1)); then
		tmp="5"
		for ((idx = ${#numbers[@]} - 1; idx >= 0; idx--)); do tmp="$tmp $((numbers[idx]))"; done
		echo "$tmp" && return
	fi
	###########
	# Stright #
	###########
	if [[ "${numbers2[*]}" == "$tmp" ]]; then
		echo "4 $((max))" && return
	fi
	###################
	# Three of a Kind #
	###################
	if [[ "${counts[*]}" == "3 1 1" || "${counts[*]}" == "1 3 1" || "${counts[*]}" == "1 1 3" ]]; then
		max=-1000
		min=1000
		for arg in "${!counts[@]}"; do
			if [ "${counts[$arg]}" -eq 3 ]; then tmp="$arg" && continue; fi
			((max = arg >= max ? arg : max))
			((min = arg <= min ? arg : min))
		done
		echo "3 $max $min" && return
	fi
	############
	# Two pair #
	############
	if [[ "${counts[*]}" == "2 2 1" || "${counts[*]}" == "2 1 2" || "${counts[*]}" == "1 2 2" ]]; then
		max=-1000
		min=1000
		for arg in "${!counts[@]}"; do
			if [ "${counts[$arg]}" -eq 2 ]; then
				((max = arg >= max ? arg : max))
				((min = arg <= min ? arg : min))
				continue
			fi
			tmp="$arg"
		done
		echo "2 $max $min $tmp" && return
	fi
	############
	# One pair #
	############
	if [[ "${counts[*]}" == *2* ]]; then
		suites=()
		for arg in "${!counts[@]}"; do
			tmp="${counts[$arg]}"
			if [ "$tmp" -eq 2 ]; then max="$arg"; else suites+=("$((arg))"); fi
		done
		readarray -t suites < <(echo "${suites[*]}" | tr " " "\n" | sort -r)

		echo "1 $max ${suites[*]}" && return
	fi
	#############
	# High card #
	#############
	readarray -t suites < <(echo "${numbers[*]}" | tr " " "\n" | sort -r)
	echo "0 ${suites[*]}"
}

main() {
	local arg
	local -A mapped_hands scored_hands
	for arg in "$@"; do
		mapped_hands["$arg"]="$(map_hand "$arg")"
		scored_hands["$arg"]="$(score_hand "${mapped_hands[$arg]}")"
	done

	for arg in "${!mapped_hands[@]}"; do
		echo -e "Maps:\t$arg:\t${mapped_hands[$arg]}"
		echo -e "Scored:\t$arg:\t${scored_hands[$arg]}"
	done
}

main "$@"
