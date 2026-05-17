#!/usr/bin/env bash
validate() {
	if test "$#" -ne 1 && test "$#" -ne 2; then
		echo "1 or 2 arguments expected" >/dev/stderr && exit 1
	fi
	if test "$#" -eq 2 && test "$1" -lt "$2"; then
		echo "Start must be greater than End" >/dev/stderr && exit 1
	fi
}
write_verse() {
	if test "$1" -eq 0; then
		echo "No more bottles of beer on the wall, no more bottles of beer."
		echo "Go to the store and buy some more, 99 bottles of beer on the wall."
	elif test "$1" -eq 1; then
		echo "1 bottle of beer on the wall, 1 bottle of beer."
		echo "Take it down and pass it around, no more bottles of beer on the wall."
	elif test "$1" -eq 2; then
		echo "2 bottles of beer on the wall, 2 bottles of beer."
		echo "Take one down and pass it around, 1 bottle of beer on the wall."
	else
		local -i next
		((next = $1 - 1))
		echo "$1 bottles of beer on the wall, $1 bottles of beer."
		echo "Take one down and pass it around, $next bottles of beer on the wall."
	fi
}

main() {
	local i
	validate "$@"
	if test "$#" -eq 1; then
		write_verse "$1"
	else
		for ((i = $1; i >= $2; i--)); do
			write_verse "$i"
			echo ""
		done
	fi

}
main "$@"
