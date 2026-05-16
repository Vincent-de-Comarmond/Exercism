#!/usr/bin/env bash
main() {
	local i word tmp="${*,,}" i
	local -a word_order tmp_arr
	local -A word_count
	tmp=$(tr ',!@$?^%&:.*' " " <<<"$tmp")
	read -ra tmp_arr -d '' <<<"$tmp" # NOTE - this is the glob safe pattern

	for word in "${tmp_arr[@]}"; do
		word="${word#\'}"
		word="${word%\'}"
		[[ "$word" == "" ]] && continue
		grep -qEv "\b$word\b" <<<"${word_order[@]}" && word_order+=("$word")
		((word_count["$word"]++))
	done

	for ((i = 0; i < "${#word_order[@]}"; i++)); do
		echo "${word_order[$i]}: ${word_count[${word_order[$i]}]}"
	done
}

main "$@"
