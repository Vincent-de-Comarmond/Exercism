#!/usr/bin/env bash

#############
# Changelog #
#############
# 1. autoformatting (shfmt)
# 2. put in main function
# 3. Made separate function for replacing strongs
# 4. Removed weird X$var = X tests

replace_strong() {
	local line="$1" pre post
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

		if [[ "$line" =~ ^\* ]]; then
			if [ "$inside_a_list" != yes ]; then
				h="$h<ul>"
				inside_a_list=yes
			fi
			line=$(replace_emphasis "$line")
			h="$h<li>${line#??}</li>" # Strips next 2 vcharacters

		else
			if [ "$inside_a_list" == yes ]; then
				h="$h</ul>"
				inside_a_list=no
			fi

			n=$(expr "$line" : "#\{1,\}")
			if [ $n -gt 0 -a 7 -gt $n ]; then

				while [[ $line == *_*?_* ]]; do
					s=${line#*_}
					t=${s#*_}
					if [ ${#t} -lt ${#s} -a ${#s} -lt ${#line} ]; then
						line="${line%%_$s}<em>${s%%_$t}</em>$t"
					fi
				done
				HEAD=${line:n}
				while [[ $HEAD == " "* ]]; do HEAD=${HEAD# }; done
				h="$h<h$n>$HEAD</h$n>"

			else

				grep '_..*_' <<<"$line" >/dev/null &&
					line=$(echo "$line" | sed -E 's,_([^_]+)_,<em>\1</em>,g')
				h="$h<p>$line</p>"
			fi
		fi
	done <"$1"

	if [ "$inside_a_list" == yes ]; then
		h="$h</ul>"
	fi

	echo "$h"
}

main "$1"
