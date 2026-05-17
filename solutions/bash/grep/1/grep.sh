#!/usr/bin/env bash
main() {
	local -i flag_n=0 flag_l=0 flag_i=0 flag_v=0 flag_x=0 idx=0 matched=0 multiple=0
	local pattern file pattern_matcher line_matcher line
	local -A file_matches

	while (($# > 0)); do
		case "$1" in
		"-n") flag_n=1 ;;
		"-l") flag_l=1 ;;
		"-i") flag_i=1 ;;
		"-v") flag_v=1 ;;
		"-x") flag_x=1 ;;
		*) break ;;
		esac
		shift
	done

	pattern="$1"
	shift
	((($# > 1) && (multiple = 1) || (multiple = 0)))

	for file in "$@"; do
		((idx = 0))
		((matched = 0))
		while IFS= read -r line; do
			((idx++))
			((flag_i == 1)) && pattern_matcher="${pattern^^}" || pattern_matcher="$pattern"
			((flag_i == 1)) && line_matcher="${line^^}" || line_matcher="$line"
			((flag_x == 1)) && pattern_matcher="^$pattern_matcher$" || :
			[[ "$line_matcher" =~ $pattern_matcher ]] && matched=1 || matched=0 # Note -x pattern

			if ((matched == 1 && flag_v == 0)) || ((matched == 0 && flag_v == 1)); then
				if [ "$flag_l" -eq 1 ]; then
					file_matches["$file"]=1
					break
				fi
				((multiple == 1)) && printf "%s:" "$file" || :
				((flag_n == 1)) && printf "%d:" "$idx" || :
				printf "%s\n" "$line"
			fi
		done <"$file"
	done

	if [ "$flag_l" -eq 1 ]; then
		tr " " "\n" <<<"${!file_matches[@]}" | sort
	fi
}

main "$@"
