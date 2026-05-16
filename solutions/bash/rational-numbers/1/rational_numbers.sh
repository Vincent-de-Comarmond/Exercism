#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

gcd() {
	if (($1 == 0)); then echo "$2" && return; fi
	if (($2 == 0)); then echo "$1" && return; fi
	gcd "$2" $(($1 % $2))
}

reduce() {
	local -i div
	div="$(gcd "$1" "$2")"
	if [[ "$div" -ne 1 ]]; then
		reduce $(($1 / div)) $(($2 / div))
	else
		if (($2 < 0)); then echo $((-$1)) $((-$2)); else echo "$1" "$2"; fi
	fi
}

abs() { reduce $(($1 < 0 ? -$1 : $1)) $(($2 < 0 ? 0 - $2 : $2)); }
divide() { reduce $(($1 * $4)) $(($2 * $3)); }
minus() { reduce $(($1 * $4 - $2 * $3)) $(($2 * $4)); }
multiply() { reduce $(($1 * $3)) $(($2 * $4)); }
plus() { reduce $(($1 * $4 + $2 * $3)) $(($2 * $4)); }
pow() {
	local -i n=$(($3 < 0 ? $2 : $1)) d=$(($3 < 0 ? $1 : $2)) pow=$(($3 < 0 ? -$3 : $3))
	reduce $((n ** pow)) $((d ** pow))
}

stupid_root() {
	local -i est=0 num den
	read -r num den < <(pow "$est" 1 "$2")
	while ((num < $1)); do
		((est++))
		read -r num den < <(pow "$est" 1 "$2")
	done
	if ((num != $1)); then die "Cannot find root of non-perfect root number"; fi
	echo "$est"
}

long_div() {
	local -i i=0 n="$1" d="$2" whole=0 deci=0 rem
	((whole = n / d))
	if ((n % d == 0)); then
		echo "$whole.$deci"
		return
	fi

	((rem = 10 * (n % d)))
	for ((i = 0; i < 6; i++)); do
		if ((rem == 0)); then break; fi
		((deci *= 10))
		((deci += rem / d))
		((rem = 10 * (rem % d)))
	done
	echo "$whole.$deci"
}

rpow() {
	local -i n d
	read -r n d <<<"$(pow "$1" 1 "$3")"
	n="$(stupid_root "$n" "$4")"
	d="$(stupid_root "$d" "$4")"
	echo "$n $d"
}

main() {
	local func
	local -i n1 d1 n2 d2 nR dR
	func="${1/+/plus}"
	func="${func/-/minus}"
	func="${func/\*/multiply}"
	func="${func/\//divide}"

	IFS="/" read -r n1 d1 <<<"$2"
	IFS="/" read -r n2 d2 <<<"$3"

	read -r nR dR < <("$func" "$n1" "$d1" "$n2" "$d2")
	if [ "$1" != "rpow" ]; then
		printf "%d/%d\n" "$nR" "$dR"
	else
		long_div "$nR" "$dR"
	fi
}
main "$@"
