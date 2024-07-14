#!/usr/bin/env bash

#############
# Changelog #
#############
# 1. autoformatting (shfmt)
# 2. put in main function
# 3. Made separate function for replacing strongs
# 4. Removed weird X$var = X tests
# 5. Made a seperate function for replacing emphasis and replaced usages thereof in main

replace_strong() {
	local line="$1"
	if [[ "$line" =~ ^(.*)__(.*)__(.*) ]]; then
		printf -v line "%s<strong>%s</strong>%s" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
		replace_strong "$line"
		return
	fi
	echo -n "$line"
}

replace_emphasis() {
	local line="$1"
	if [[ $line =~ ^(.*)_(.*)_(.*) ]]; then
		printf -v line "%s<em>%s</em>%s" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
		replace_emphasis "$line"
		return
	fi
	echo -n "$line"
}

main() {
	local inside_a_list=""
	while IFS= read -r line; do
		line=$(replace_strong "$line")
		line=$(replace_emphasis "$line")

		if [[ "$line" =~ ^\* ]]; then
			if [ "$inside_a_list" != yes ]; then
				h="$h<ul>"
				inside_a_list=yes
			fi
			h="$h<li>${line#??}</li>" # Strips 2 characters following line (why?)
			continue
		fi

		if [ "$inside_a_list" == yes ]; then
			h="$h</ul>"
			inside_a_list=no
		fi

		if [[ "$line" =~ ^(#*)[[:space:]]+(.*) ]]; then
			if [ "${#BASH_REMATCH[1]}" -lt 7 ]; then
				h="$h<h${#BASH_REMATCH[1]}>${BASH_REMATCH[2]}</h${#BASH_REMATCH[1]}>"
				continue
			fi
		fi
		h="$h<p>$line</p>"

	done <"$1"

	if [ "$inside_a_list" == yes ]; then
		h="$h</ul>"
	fi

	echo "$h"
}

main "$1"
