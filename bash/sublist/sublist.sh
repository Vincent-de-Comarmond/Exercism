#!/usr/bin/env bash
sub_super_p() {
	local -n array1="$1" array2="$2" smaller larger
	local value contained_p=1
	[[ "${#array1[@]}" -le "${#array2[@]}" ]] && smaller=array1 && larger=array2
	[[ "${#array1[@]}" -gt "${#array2[@]}" ]] && smaller=array2 && larger=array1

	value="${smaller[*]}" # Trying to get grep to escape this directly was not going well
	grep -qEv "\b$value\b" <<<"${larger[@]}" && contained_p=0
	echo "$contained_p"
}

main() {
	local -i passed AminB
	local -a A B
	read -ra A <<<"${1//[^0-9 ]/}"
	read -ra B <<<"${2//[^0-9 ]/}"
	((AminB = ${#A[@]} - ${#B[@]}))
	[[ "${#A[@]}" -eq "${#B[@]}" && "${#B[@]}" -eq 0 ]] && echo "equal" && return

	passed="$(sub_super_p A B)"
	if ((passed == 0)); then
		echo "unequal"
	else
		case "$AminB" in
		0) echo "equal" ;;
		-[0-9]) echo "sublist" ;;
		*) echo "superlist" ;;
		esac
	fi
}

main "$@"
