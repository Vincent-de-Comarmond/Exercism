#!/usr/bin/env bash

#############
# Changelog #
#############
# 1. autoformatting (shfmt)
# 2. put in main function
# 3. Made separate function for replacing strongs
# 4. Removed weird X$var = X tests
# 5. Made a seperate function for replacing emphasis and replaced usages thereof in main
# 6. Made separate function for handling header or paragraph
# 7. Simplified code

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

add_header_or_para() {
	local line="$1"
	if [[ "$line" =~ ^(#*)[[:space:]]+(.*) ]]; then
		if [ "${#BASH_REMATCH[1]}" -lt 7 ]; then
			echo -n "<h${#BASH_REMATCH[1]}>${BASH_REMATCH[2]}</h${#BASH_REMATCH[1]}>"
			return
		fi
	fi
	echo -n "<p>$line</p>"

}

main() {
	local inside_a_list="" content=""
	while IFS= read -r line; do
		line=$(replace_strong "$line")
		line=$(replace_emphasis "$line")

		if [[ "$line" =~ ^\* ]]; then
			[ "$inside_a_list" != yes ] && content="$content<ul>"
			[ "$inside_a_list" != yes ] && inside_a_list=yes
			# Strips 2 leading characters to undo the markdown * list syntax
			content="$content<li>${line#??}</li>"
		else
			[ "$inside_a_list" == yes ] && content="$content</ul>"
			[ "$inside_a_list" == yes ] && inside_a_list=no
			content="$content$(add_header_or_para "$line")"
		fi
	done <"$1"

	[ "$inside_a_list" == yes ] && content="$content</ul>"
	echo "$content"
}

main "$1"
