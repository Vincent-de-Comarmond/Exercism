#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

process() {
	local arg tmp
	local -a stack # Can make global if needed
	local -a one_arg_ops=("dup" "drop") two_arg_ops=("+" "-" "*" "/" "swap" "over")
	for arg in "$@"; do
		if [[ "$arg" =~ ^-?[0-9]+$ ]]; then stack+=("$arg") && continue; fi

		# Check if valid
		if [[ "${one_arg_ops[*]}" != *"$arg"* && "${two_arg_ops[*]}" != *"$arg"* ]]; then die "undefined operation"; fi
		if ((${#stack[@]} == 0)); then die "empty stack"; fi
		if [[ "$arg" == "/" && "${stack[-1]}" -eq 0 ]]; then die "divide by zero"; fi
		if [[ "${two_arg_ops[*]}" == *"$arg"* && "${#stack[@]}" -eq 1 ]]; then die "only one value on the stack"; fi

		case "$arg" in
		"+" | "-" | "*" | "/")
			case "$arg" in
			"+") ((tmp = stack[-2] + stack[-1])) ;;
			"-") ((tmp = stack[-2] - stack[-1])) ;;
			"*") ((tmp = stack[-2] * stack[-1])) ;;
			"/") ((tmp = stack[-2] / stack[-1])) ;;
			esac
			unset "stack[-1]"
			unset "stack[-1]"
			stack+=("$tmp")
			;;
		"dup") stack+=("${stack[-1]}") ;;
		"drop") unset "stack[-1]" ;;
		"swap")
			((tmp = stack[-2]))
			stack[-2]="${stack[-1]}"
			stack[-1]="$tmp"
			;;
		"over") stack+=("${stack[-2]}") ;;
		esac

	done

	echo "${stack[@]}"
}

forth() {
	local line tmp1 tmp2 key replacement
	local -A macros=()
	#################
	# Handle Macros #
	#################
	while read -r line && test -n "$line"; do
		line="${line,,}"

		if [[ "$line" =~ ^: ]]; then
			read -r -a tmp1 <<<"$line"
			if [ "${tmp1[-1]}" != ";" ]; then die "macro not terminated with semicolon"; fi
			if [ "${#tmp1[@]}" -le 3 ]; then die "empty macro definition"; fi
			if [[ "${tmp1[1]}" =~ -?[0-9]+ ]]; then die "illegal operation"; fi
			tmp2="${tmp1[@]:2:${#tmp1[@]}-3}"

			for key in "${!macros[@]}"; do
				replacement="${macros[$key]}"
				tmp2="${tmp2//$key/$replacement}"
			done

			macros["${tmp1[1]}"]="$tmp2"
			continue
		else
			for key in "${!macros[@]}"; do
				replacement="${macros[$key]}"
				line="${line//$key/$replacement}"
			done
			read -r -a tmp1 <<<"$line"
		fi

		process "${tmp1[@]}"
	done <"${@:-/dev/stdin}"
}

forth "$@"
