#!/usr/bin/env bash
validate() {
	[ "$#" -ne 4 ] && echo "Incorrect number of arguments" && exit 1
	[ "$1" != equilateral ] && [ "$1" != isosceles ] && [ "$1" != scalene ] && echo "Invalid triangle type" && exit 1
	local pattern="^[0-9]+(\.[0-9]+)?$"
	if [[ ! "$2" =~ $pattern ]] || [[ ! "$3" =~ $pattern ]] || [[ ! "$4" =~ $pattern ]]; then
		echo "Invalid length entered"
		exit 1
	fi
}

triangle_p() {
	local nonzero triangle_ineq
	nonzero=$(bc <<<"($1>0) + ($2>0) + ($3>0)")
	triangle_ineq=$(bc <<<"($1 < ($2 +$3)) && ($2 < ($1+$3)) && ($3 < ($1+$2))")
	if ((nonzero == 3)) && ((triangle_ineq == 1)); then
		echo "true" && return
	fi
	echo "false"
}

main() {
	local is_triangle tmp
	is_triangle=$(triangle_p "${@:2}")
	if [ "$is_triangle" != "true" ]; then
		echo "false" && return
	fi
	case "$1" in
	equilateral)
		tmp=$(bc <<<"($2==$3)&&($2==$4)")
		;;
	isosceles)
		tmp=$(bc <<<"($2==$3)||($2==$4)||($3==$4)")
		;;
	scalene)
		tmp=$(bc <<<"($2!=$3)&&($2!=$4)&&($3!=$4)")
		;;
	esac

	if [ "$tmp" -eq 1 ]; then
		echo "true"
	else
		echo "false"
	fi

}

validate "$@"
main "$@"
