#!/usr/bin/env bash

roll_dice() {
	echo $((RANDOM % 6 + 1))
}

generate_score() {
	local dice1=0 dice2=0 dice3=0 roll _
	for _ in {1..4}; do
		roll=$(roll_dice)
		if [ "$roll" -gt "$dice1" ]; then
			dice3="$dice2"
			dice2="$dice1"
			dice1="$roll"
		elif [ "$roll" -gt "$dice2" ]; then
			dice3="$dice2"
			dice2="$roll"
		elif [ "$roll" -gt "$dice3" ]; then
			dice3="$roll"
		fi
	done
	echo "$((dice1 + dice2 + dice3))"
}

modifier() {
	echo $((($1 - ($1 % 2) - 10) / 2))
}

generate() {
	local hitpoints score tmp
	for score in strength dexterity constitution intelligence wisdom charisma; do
		tmp="$(generate_score)"
		echo "$score $tmp"
		if [ "$score" == "constitution" ]; then
			((hitpoints = 10 + (tmp - (tmp % 2) - 10) / 2))
		fi
	done
	echo "hitpoints $hitpoints"
}

main() {
	[ "$1" == "modifier" ] && modifier "$2" && return
	[ "$1" == "generate" ] && generate && return
}

main "$@"
