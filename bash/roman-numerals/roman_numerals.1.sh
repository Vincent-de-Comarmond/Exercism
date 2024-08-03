#!/usr/bin/env bash
declare -A numerals=([M]=1000 [D]=500 [C]=100 [L]=50 [X]=10 [V]=5 [I]=1)
declare -A numerals=([1000]=M [500]=D [100]=C [50]=L [10]=X [5]=V [1]=I)

reduce() {
	if (($2 >= 1000)); then echo "$1M" $(($2 - 1000)) && return; fi
	if (($2 >= 900)); then echo "$1CM" $(($2 - 900)) && return; fi
	if (($2 >= 500)); then echo "$1D" $(($2 - 500)) && return; fi
	if (($2 >= 400)); then echo "$1CD" $(($2 - 400)) && return; fi
	if (($2 >= 100)); then echo "$1C" $(($2 - 100)) && return; fi
	if (($2 >= 90)); then echo "$1XC" $(($2 - 90)) && return; fi
	if (($2 >= 50)); then echo "$1L" $(($2 - 50)) && return; fi
	if (($2 >= 40)); then echo "$1XL" $(($2 - 40)) && return; fi
	if (($2 >= 10)); then echo "$1X" $(($2 - 10)) && return; fi
	if (($2 >= 9)); then echo "$1IX" $(($2 - 9)) && return; fi
	if (($2 >= 5)); then echo "$1V" $(($2 - 5)) && return; fi
	if (($2 >= 4)); then echo "$1IV" $(($2 - 4)) && return; fi
	if (($2 >= 1)); then echo "$1I" $(($2 - 1)) && return; fi
}

main() {
	local -i input="$1"
	local output=""

	while ((input > 0)); do
		read -r output input < <(reduce "$output" "$input")
	done
	echo "$output"
}

main "$1"
