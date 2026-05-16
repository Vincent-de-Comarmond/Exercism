#!/usr/bin/env bash
main() {
	if [[ ! "$1" =~ ^[ACGT]*$ ]]; then
		echo "Invalid nucleotide in strand" >/dev/stderr
		exit 1
	fi
	local tmp nucleotide
	for nucleotide in A C G T; do
		tmp="${1//[^$nucleotide]/}"
		printf "%s: %d\n" "$nucleotide" "${#tmp}"
	done
}
main "$*"
