#!/usr/bin/env bash

map_hand() {
	echo "$1" | sed -E -e 's/(\w+)/0\1/g' -e 's/A/14/g' -e 's/J/11/g' -e 's/Q/12/g' -e 's/K/13/g' -e 's/0([0-9][0-9])/\1/g' | tr " " "\n" | sort | tr "\n" " "
	echo ""
}

minimax() {
	local arg min=1000 max=-1000
	for arg in "$@"; do
		if [ "${arg#0}" -le "$min" ]; then min="$arg"; fi
		if [ "${arg#0}" -ge "$max" ]; then max="$arg"; fi
	done
	echo "$min $max"
}

isstraight() {
	local arg prev=""
	if [[ "$*" == "02 03 04 05 14" ]]; then echo "true" && return; fi
	for arg in "$@"; do
		arg="${arg#0}"
		if [ "$prev" == "" ]; then prev="$arg"; elif ((arg - prev != 1)); then echo "false" && return; fi
		prev="$arg"
	done
	echo "true"
}

score_hand() {
	local arg min max tmp idx straight_p
	local -a hand suites numbers
	local -A counts

	read -r -a hand <<<"$1"
	readarray -t suites < <(for arg in "${hand[@]}"; do echo "${arg:${#arg}-1}"; done | uniq)
	readarray -t numbers < <(for arg in "${hand[@]}"; do echo "${arg:0:-1}"; done)
	read -r min max < <(minimax "${numbers[@]}")
	read -r straight_p < <(isstraight "${numbers[@]}")
	for arg in "${numbers[@]}"; do ((counts[$arg]++)); done

	##################
	# Straight Flush #
	##################
	if [[ "${#suites[@]}" -eq 1 && "$straight_p" == "true" ]]; then
		if [ "${numbers[*]}" == "02 03 04 05 14" ]; then max=05; fi
		echo "8 $max" && return
	fi
	##################
	# Four of a kind #
	##################
	if [[ "${counts[*]}" == "1 4" || "${counts[*]}" == "4 1" ]]; then
		for tmp in "${!counts[@]}"; do
			if [ "${counts[$tmp]}" -eq 1 ]; then min="$tmp" && continue; fi
			max="$tmp"
		done
		echo "7 $max $min" && return
	fi
	##############
	# Full House #
	##############
	if [[ "${counts[*]}" == "2 3" || "${counts[*]}" == "3 2" ]]; then
		for tmp in "${!counts[@]}"; do
			if [ "${counts[$tmp]}" -eq 2 ]; then min="$tmp" && continue; fi
			max="$tmp"
		done
		echo "6 $max $min" && return
	fi
	#########
	# Flush #
	#########
	if ((${#suites[@]} == 1)); then
		tmp="5"
		for ((idx = ${#numbers[@]} - 1; idx >= 0; idx--)); do tmp="$tmp ${numbers[$idx]}"; done
		echo "$tmp" && return
	fi
	###########
	# Stright #
	###########
	if [[ "$straight_p" == "true" ]]; then
		if [ "${numbers[*]}" == "02 03 04 05 14" ]; then max=05; fi
		echo "4 $max" && return
	fi
	###################
	# Three of a Kind #
	###################
	if [[ "${counts[*]}" == "3 1 1" || "${counts[*]}" == "1 3 1" || "${counts[*]}" == "1 1 3" ]]; then
		max=-1000
		min=1000
		for arg in "${!counts[@]}"; do
			if [ "${counts[$arg]}" -eq 3 ]; then tmp="$arg" && continue; fi
			if [ "${arg#0}" -ge "$max" ]; then max="$arg"; fi
			if [ "${arg#0}" -le "$min" ]; then min="$arg"; fi
		done
		echo "3 $tmp $max $min" && return
	fi
	############
	# Two pair #
	############
	if [[ "${counts[*]}" == "2 2 1" || "${counts[*]}" == "2 1 2" || "${counts[*]}" == "1 2 2" ]]; then
		max=-1000
		min=1000
		for arg in "${!counts[@]}"; do
			if [ "${counts[$arg]}" -eq 2 ]; then
				if [ "${arg#0}" -ge "$max" ]; then max="$arg"; fi
				if [ "${arg#0}" -le "$min" ]; then min="$arg"; fi
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
			if [ "$tmp" -eq 2 ]; then max="$arg"; else suites+=("$arg"); fi
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
	local arg best
	local -A mapped_hands scored_hands
	for arg in "$@"; do
		mapped_hands["$arg"]="$(map_hand "$arg")"
		scored_hands["$arg"]="$(score_hand "${mapped_hands[$arg]}")"
	done

	read -r best < <(for arg in "${scored_hands[@]}"; do echo "$arg"; done | sort -r | head -n1)

	for arg in "${!scored_hands[@]}"; do
		if [ "${scored_hands[$arg]}" == "$best" ]; then
			echo "$arg"
		fi
	done
}

main "$@"
