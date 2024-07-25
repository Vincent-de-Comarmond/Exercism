#!/usr/bin/env bash
main() {
	local i sum=0 _in="${1//-/}"
	if [[ "${#_in}" -ne 10 || ! "${_in:0:9}" =~ ^[0-9]+$ || ! "${_in:9:1}" =~ [0-9X] ]]; then
		echo false
		return
	fi
	for ((i = 0; i < 10; i++)); do
		if [ "${_in:$i:1}" == X ]; then ((sum += 10)); else ((sum += ${_in:$i:1} * (10 - i))); fi
	done
	if ((sum % 11 == 0)); then echo true; else echo false; fi
}

main "$1"
