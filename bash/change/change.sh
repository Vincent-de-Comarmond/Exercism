#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

_gcd2() { if (($1 == 0 || $2 == 0)); then echo $(($1 + $2)); else _gcd2 "$2" $(($1 % $2)); fi; }
gcd() {
	local -i seed="$1" num && shift
	for num in "$@"; do read -r seed < <(_gcd2 "$seed" "$num"); done
	echo "$seed"
}

gen_distributions() {
	local -n seed="$1"
	local distri_str i
	local -a distri distributions
	for distri_str in "${seed[@]}"; do
		read -r -a distri <<<"$distri_str"
		for ((i = 0; i < ${#distri[@]}; i++)); do
			((distri[i]++))
			distributions+=("${distri[*]}")
			((distri[i]--))
		done
	done
	for distri_str in "${distributions[@]}"; do echo "$distri_str"; done
}

mult() {
	local -i i _sum=0
	local -n _numbers="$1" _coins="$2"
	for i in "${!_numbers[@]}"; do ((_sum += _numbers[i] * _coins[i])); done
	echo "$_sum"
}

main() {
	local _gcd tmp soln="" target="$1"
	shift
	local -a coins=("$@") root vector

	read -r _gcd < <(gcd "${coins[@]}")
	if ((target % _gcd != 0)); then die "No solution"; fi

	for _ in "${coins[@]}"; do root[0]="${root[0]} 0"; done
	root[0]="${root[0]# }"

	while :; do
		readarray -t root < <(gen_distributions root)
		for tmp in "${root[@]}"; do
			read -r -a vector <<<"$tmp"
			read -r tmp < <(mult vector coins)
			if ((tmp == target)); then break 2; fi
		done
	done

	for tmp in "${!vector[@]}"; do
		for ((i = 1; i <= vector[tmp]; i++)); do soln="$soln ${coins[$tmp]}"; done
	done
	echo "${soln# }"
}

main "$@"
