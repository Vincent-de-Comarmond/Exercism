#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

forth() {
	local arg tmp1 tmp2
	local -a input=() stack=()
	read -r -a input <"${@:-/dev/stdin}"

	for arg in "${input[@]}"; do
		if [[ "$arg" =~ ^-?[0-9]+$ ]]; then
			stack+=("$arg")
		elif [[ "$arg" == "+" || "$arg" == "-" || "$arg" == "*" || "$arg" == "/" ]]; then
			if ((${#stack[@]} == 0)); then die "empty stack"; fi
			if ((${#stack[@]} == 1)); then die "only one value on the stack"; fi
			if ((stack[-1] == 0)) && [ "$arg" == "/" ]; then die "divide by zero"; fi

			if [ "$arg" == "+" ]; then ((tmp1 = stack[-2] + stack[-1])); fi
			if [ "$arg" == "-" ]; then ((tmp1 = stack[-2] - stack[-1])); fi
			if [ "$arg" == "*" ]; then ((tmp1 = stack[-2] * stack[-1])); fi
			if [ "$arg" == "/" ]; then ((tmp1 = stack[-2] / stack[-1])); fi

			unset "stack[-1]"
			unset "stack[-1]"
			stack+=("$tmp1")
		elif [ "$arg" == "dup" ]; then
			if ((${#stack[@]} == 0)); then die "empty stack"; fi
			stack+=("${stack[-1]}")
		elif [ "$arg" == "drop" ]; then
			if ((${#stack[@]} == 0)); then die "empty stack"; fi
			unset "stack[-1]"
		elif [ "$arg" == "swap" ]; then
			if ((${#stack[@]} == 0)); then die "empty stack"; fi
			if ((${#stack[@]} == 1)); then die "only one value on the stack"; fi
			((tmp1 = stack[-2]))
			stack[-2]="${stack[-1]}"
			stack[-1]="$tmp1"
		elif [ "$arg" == "over" ]; then
			if ((${#stack[@]} == 0)); then die "empty stack"; fi
			if ((${#stack[@]} == 1)); then die "only one value on the stack"; fi
			stack+=("${stack[-2]}")
		fi
	done

	echo "${stack[@]}"
}

forth "$@"
