#!/usr/bin/env bash
die() {
	echo "$1" >/dev/stderr && exit 1
}

plus() {
	echo $(($1 + $2))
}

minus() {
	echo $(($1 - $2))
}

multiplied_by() {
	echo $(($1 * $2))
}

divided_by() {
	echo $(($1 / $2))
}

main() {
	if [[ ! "$1" =~ ^"What is" ]]; then die "unknown operation"; fi

	local -a word_array
	local modified action
	modified="${1//multiplied by/multiplied_by}"
	modified="${modified//divided by/divided_by}"
	modified="${modified/What is/}"
	modified="${modified/\?/}"

	read -a word_array <<<"$modified"
	local -i i result
	for i in "${!word_array[@]}"; do
		if ((i % 2 == 0)); then
			if [[ ! "${word_array[$i]}" =~ [0-9]+ ]]; then die "syntax error"; fi
			if [ "$i" -eq 0 ]; then
				result="${word_array[$i]}"
			else
				result=$($action "$result" "${word_array[$i]}")
				action=""
			fi
		else
			if [[ "${word_array[$i]}" =~ plus|minus|multiplied_by|divided_by ]]; then
				action="${word_array[$i]}"
			else
				if [[ "${word_array[$i]}" =~ [0-9]+ ]]; then die "syntax error"; else die "unknown operation"; fi
			fi
		fi

	done
	if [ "$result" == "" ] || [ "$action" != "" ]; then die "syntax error"; fi
	echo "$result"
}

main "$1"
