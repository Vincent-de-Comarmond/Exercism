#!/usr/bin/env bash
main() {
	local -a anagrams
	local raw candidate target
	for raw in $2; do
		target="${1^^}"
		candidate="${raw^^}"
		if [ "$target" == "$candidate" ]; then
			continue
		fi

		while read -r -n1 char; do
			if [ "$char" != "" ]; then
				if [[ "${candidate}" == *"$char"* ]]; then
					candidate="${candidate/$char/}"
				else
					candidate="Not an anagram"
					break
				fi
			fi

		done <<<"$target"
		if [ "${#candidate}" -eq 0 ]; then
			anagrams+=("$raw")
		fi
	done
	echo "${anagrams[@]}"
}
main "$@"
