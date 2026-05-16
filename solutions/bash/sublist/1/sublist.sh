#!/usr/bin/env bash
sub_super_p() {
	local -n array1="$1" array2="$2" smaller larger
	local value contained_p=1
	[[ "${#array1[@]}" -le "${#array2[@]}" ]] && smaller=array1 && larger=array2
	[[ "${#array1[@]}" -gt "${#array2[@]}" ]] && smaller=array2 && larger=array1

	value="${smaller[@]}" # Trying to get grep to escape this directly was not going well
	grep -qEv "\b$value\b" <<<"${larger[@]}" && contained_p=0
	echo "$contained_p"
}

main() {
	local -a A=($(echo "${1//[^0-9 ]/}")) B=($(echo "${2//[^0-9 ]/}"))
	[[ "${#A[@]}" -eq "${#B[@]}" && "${#B[@]}" -eq 0 ]] && echo "equal" && return

	local passed="$(sub_super_p A B)"
	[ "$passed" -eq 0 ] && echo "unequal" && return
	[ "${#A[@]}" -eq "${#B[@]}" ] && echo "equal" && return
	[ "${#A[@]}" -lt "${#B[@]}" ] && echo "sublist" && return
	[ "${#A[@]}" -gt "${#B[@]}" ] && echo "superlist" && return
}

main "$@"
