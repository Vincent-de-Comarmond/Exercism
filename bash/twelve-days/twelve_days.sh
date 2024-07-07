#!/usr/bin/env bash
verse() {
	local i="$1" start end

	local -A positions=(
		[1]="first" [2]="second" [3]="third" [4]="fourth"
		[5]="fifth" [6]="sixth" [7]="seventh" [8]="eighth"
		[9]="ninth" [10]="tenth" [11]="eleventh" [12]="twelfth"
	)
	local -A numbers=(
		[1]="a" [2]="two" [3]="three" [4]="four" [5]="five" [6]="six" [7]="seven"
		[8]="eight" [9]="nine" [10]="ten" [11]="eleven" [12]="twelve"
	)
	local -A objects=(
		[1]="Partridge in a Pear Tree" [2]="Turtle Doves" [3]="French Hens"
		[4]="Calling Birds" [5]="Gold Rings" [6]="Geese-a-Laying"
		[7]="Swans-a-Swimming" [8]="Maids-a-Milking" [9]="Ladies Dancing"
		[10]="Lords-a-Leaping" [11]="Pipers Piping" [12]="Drummers Drumming"
	)
	echo -n "On the ${positions[$i]} day of Christmas my true love gave to me: "
	for (( ; i > 0; i--)); do
		[ "$i" -eq 1 ] && [ "$1" -ne 1 ] && start="and "
		[ "$i" -eq 1 ] && end=".\n" || end=", "
		echo -e -n "$start${numbers[$i]} ${objects[$i]}$end"
	done
}

main() {
	for ((i = $1; i <= $2; i++)); do
		verse "$i"
	done
}

main "$@"
