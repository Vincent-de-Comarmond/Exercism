#!/usr/bin/env bash
main() {
	local team1 team2 result team
	local -A mp w d l p

	while IFS=";" read -r team1 team2 result; do
		if [ "$team1" == "" ] || [ "$team2" == "" ] || [ "$result" == "" ]; then
			continue
		fi

		((mp[$team1]++))
		((mp[$team2]++))
		case "$result" in
		"win")
			((w[$team1]++))
			((p[$team1] += 3))
			((l[$team2]++))
			;;
		"draw")
			((d[$team1]++))
			((d[$team2]++))
			((p[$team1]++))
			((p[$team2]++))
			;;
		"loss")
			((w[$team2]++))
			((p[$team2] += 3))
			((l[$team1]++))
			;;
		esac
	done <"${1:-/dev/stdin}"

	echo "Team                           | MP |  W |  D |  L |  P"
	for team in "${!mp[@]}"; do
		printf "%-31s| %2s | %2s | %2s | %2s | %2s\n" "$team" "${mp[$team]}" "${w[$team]:-0}" "${d[$team]:-0}" "${l[$team]:-0}" "${p[$team]:-0}"
	done | sort -t '|' -k6,6nr -k1,1
}
main "$@"
