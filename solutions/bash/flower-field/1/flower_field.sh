#!/usr/bin/env bash

main() {
	local -a grid=("$@")
	local -i rows="$#" cols i=0 j=0
	local -i ii jj a b
	local row tmp output count

	for ((i = 0; i < rows; i++)); do
		row="${grid[$i]}" cols="${#row}" tmp="" output=""
		for ((j = 0; j < cols; j++)); do
			count=" "

			if [[ "${row:j:1}" == '*' ]]; then
				output="$output*"
				continue
			fi

			for ii in {-1..1}; do
				for jj in {-1..1}; do
					if ((ii == 0 && jj == 0)); then continue; fi
					let "a=i+ii"
					let "b=j+jj"
					if ((0 <= a && a < rows && 0 <= b && b < cols)); then
						tmp="${grid[$a]}"
						if [[ "${tmp:$b:1}" == "*" ]]; then let "count+=1"; fi
					fi
				done
			done
			output="$output$count"
		done
		echo "$output"
	done
}

main "$@"
