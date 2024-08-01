#!/usr/bin/env bash
main() {
	local -A ranges=([Sunday]="1-2" [Monday]="4-5" [Tuesday]="7-8" [Wednesday]="10-11"
		[Thursday]="13-14" [Friday]="16-17" [Saturday]="19-20")
	local -A weeks=([first]=0 [second]=1 [third]=2 [fourth]=3 [last]=-1)
	local days tmp
	read -r -a days < <(cal "$2" "$1" | tail -n +3 | cut -c "${ranges[$4]}" | paste -s)
	if [ "$3" == "teenth" ]; then
		for tmp in "${days[@]}"; do
			if [[ ! "$tmp" =~ 1[3-9] ]]; then continue; fi
			printf "%04d-%02d-%02d\n" "$1" "$2" "$tmp"
		done
	else
		printf "%04d-%02d-%02d\n" "$1" "$2" "${days[${weeks[$3]}]}"
	fi
}
main "$@"
