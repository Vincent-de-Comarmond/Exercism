#!/usr/bin/env bash

declare -A numbers=(
	[0]="No"
	[1]="One"
	[2]="Two"
	[3]="Three"
	[4]="Four"
	[5]="Five"
	[6]="Six"
	[7]="Seven"
	[8]="Eight"
	[9]="Nine"
	[10]="Ten"
)

verse() {
	local number="$1" next
	let "next=number-1"
	local object1 oject2
	if ((number == 1)); then object1="bottle"; else object1="bottles"; fi
	if ((next == 1)); then object2="bottle"; else object2="bottles"; fi

	cat <<-EOF
		${numbers[$number]} green $object1 hanging on the wall,
		${numbers[$number]} green $object1 hanging on the wall,
		And if one green bottle should accidentally fall,
		There'll be ${numbers[$next],} green $object2 hanging on the wall.
	EOF
}

main() {
	if test "$#" -ne 2; then
		if test "$#" -lt 2; then echo "2 arguments expected" >&2; fi
		if test "$#" -gt 2; then echo "2 arguments expected" >&2; fi
		return 1
	elif test "$2" -gt "$1"; then
		echo "cannot generate more verses than bottles"
		return 1
	else
		local bottles="$1" verses="$2"
		while ((0 < verses)); do
			verse "$bottles"
			let "verses-=1"
			let "bottles-=1"
			if ((0 < verses)); then echo ""; fi
		done
		return 0
	fi
}

main "$@"
