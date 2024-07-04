#!/usr/bin/env bash
main() {
	local -A translations=(
		["AUG"]="Methionine"
		["UAA"]="STOP"
		["UAC"]="Tyrosine"
		["UAG"]="STOP"
		["UAU"]="Tyrosine"
		["UCA"]="Serine"
		["UCC"]="Serine"
		["UCG"]="Serine"
		["UCU"]="Serine"
		["UGA"]="STOP"
		["UGC"]="Cysteine"
		["UGG"]="Tryptophan"
		["UGU"]="Cysteine"
		["UUA"]="Leucine"
		["UUC"]="Phenylalanine"
		["UUG"]="Leucine"
		["UUU"]="Phenylalanine"
	)
	local -a proteins
	while read -r -n3 codon; do
		[ "$codon" == "" ] && continue
		if test -v "translations[$codon]"; then
			[ "${translations[$codon]}" == "STOP" ] && break
			proteins+=("${translations[$codon]}")
		else
			echo "Invalid codon" >/dev/stderr
			exit 1
		fi
	done <<<"$1"
	echo "${proteins[@]}"
}

main "$*"
