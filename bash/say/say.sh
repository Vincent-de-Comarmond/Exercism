#!/usr/bin/env bash
declare -a tens=("" "" twenty thirty forty fifty sixty seventy eighty ninety)
declare -a units=(zero one two three four five six seven eight nine ten eleven
	twelve thirteen fourteen fifteen sixteen sevteen eighteen nineteen)

die() { echo "$1" >/dev/stderr && exit 1; }

say() {
	local -i input="$1"
	local output=""
	if ((input / 100 > 0)); then output="${units[$((input / 100))]} hundred"; fi
	((input %= 100))
	if ((input < 20 && 0 < input)); then
		output="$output ${units[$input]}"
	else
		output="$output ${tens[$((input / 10))]}"
		if ((input % 10 != 0)); then output="$output-${units[$((input % 10))]}"; fi
	fi
	echo "${output# }"
}

main() {
	if (($1 < 0 || 999999999999 < $1)); then die "input out of range"; fi
	if (($1 == 0)); then echo zero && return; fi

	local -i val input="$1"
	local level output=""
	local -A levels=([billion]=1000000000 [million]=1000000 [thousand]=1000 [" "]=1)
	for level in billion million thousand " "; do
		val="${levels[$level]}"
		if ((input >= val)); then
			printf -v output "%s %s %s" "$output" "$(say "$((input / val))")" "$level"
		fi
		((input %= val))
	done
	read -r output < <(echo "$output" | sed -e 's/  / /g' -e 's/^ //' -e 's/ $//')
	echo "$output"
}

main "$@"
