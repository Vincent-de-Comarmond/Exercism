#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

_gcd2() { if (($1 == 0 || $2 == 0)); then echo $(($1 + $2)); else _gcd2 "$2" $(($1 % $2)); fi; }
gcd() {
	local -i seed="$1" num && shift
	for num in "$@"; do read -r seed < <(_gcd2 "$seed" "$num"); done
	echo "$seed"
}

trunc_and_sort() {
	local dims="$1" trunc_len="$2" _str
	local -n src_target="$3"
	local -a tmp
	readarray -t tmp < <(
		for _str in "${src_target[@]}"; do echo "$_str"; done | sort -n -k "$dims" | head -n "$trunc_len"
	)
	src_target=()
	for _str in "${tmp[@]}"; do src_target+=("$_str"); done
}

distribute() {
	local -n coeff="$1" seed="$2"
	local -i dimensions="${#coeff[@]}"
	local distr_str targ buffer_size="${3:-1000}"
	local -a distri distributions

	for _ in {1..500}; do
		distributions=()
		for distr_str in "${seed[@]}"; do
			read -r -a distri <<<"$distr_str"
			targ="${distri[-1]}"
			distri=("${distri[@]:0:${#distri[@]}-1}")
			for ((i = 0; i < ${#distri[@]}; i++)); do
				((distri[i]++))
				if ((targ - coeff[i] == 0)); then echo "${distri[*]}" && return; fi
				if ((targ - coeff[i] > 0)); then
					distributions+=("${distri[*]} $((targ - coeff[i]))")
				fi
				((distri[i]--))
			done

			seed=()
			if ((${#distributions[@]} >= buffer_size)); then trunc_and_sort "$dimensions" "$buffer_size" distributions; fi
			for targ in "${distributions[@]}"; do seed+=("$targ"); done
		done
	done
}

main() {
	local _gcd tmp soln="" target="$1"
	shift
	local -a coins=("$@") root vector
	if ((target == 0)); then echo "" && return; fi
	if ((target < 0)); then die "target can't be negative"; fi

	read -r _gcd < <(gcd "${coins[@]}")
	if ((target % _gcd != 0)); then die "can't make target with given coins"; fi

	for _ in "${coins[@]}"; do root[0]="${root[0]} 0"; done
	root[0]="${root[0]# } $target"

	read -r -a vector < <(distribute coins root)

	for tmp in "${!vector[@]}"; do
		for ((i = 1; i <= vector[tmp]; i++)); do soln="$soln ${coins[$tmp]}"; done
	done
	echo "${soln# }"
}

main "$@"
