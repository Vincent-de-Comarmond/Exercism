#!/usr/bin/env bash
main() {
	local -i i yeardiff yearstartday monthstartday rootday=6 # For 2000-01-01 a Saturday
	local -A days=([Sunday]=0 [Monday]=1 [Tuesday]=2 [Wednesday]=3 [Thursday]=4 [Friday]=5 [Saturday]=6)
	local -A weeks=([first]=0 [second]=1 [third]=2 [fourth]=3 [last]=-1)
	local -a dates
	local -i months=(31 28 31 30 31 30 31 31 30 31 30 31)
	((yeardiff = $1 - 2000))
	((yearstartday = rootday + yeardiff))
	((yearstartday += $1 > 2000 ? 1 + (yeardiff - 1) / 4 : yeardiff / 4))
	((yearstartday = (yearstartday % 7 + 7) % 7))

	monthstartday=yearstartday
	for ((i = 0; i < $2 - 1; i++)); do
		((monthstartday = (monthstartday + months[i]) % 7))
		if ((i == 1 && ($1 % 4 == 0))); then ((monthstartday = (monthstartday + 1) % 7)); fi
	done

	for ((i = 1; i <= months[$2 - 1]; i++)); do
		if (((i + monthstartday - 1) % 7 == days[$4])); then dates+=("$i"); fi
	done
	if (($1 % 4 == 0 && $2 == 2 && (28 + monthstartday) % 7 == days[$4])); then dates+=(29); fi

	if test -v weeks["$3"]; then
		printf "%04d-%02d-%02d\n" "$1" "$2" "${dates[${weeks[$3]}]}"
	else
		printf "%04d-%02d-%02d\n" "$1" "$2" "$(echo "${dates[@]}" | grep -o '1[3-9]')"
	fi
}
main "$@"
