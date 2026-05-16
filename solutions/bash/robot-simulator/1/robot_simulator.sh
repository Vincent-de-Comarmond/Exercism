#!/usr/bin/env bash
declare -a state

advance() {
	local -i idx
	((idx = (state[2] + 1) % 2))
	((state[idx] += state[2] < 2 ? 1 : -1))
}

die() {
	echo "$1" >/dev/stderr && exit 1
}
right() { ((state[2] = (state[2] + 1) % 4)); }
left() { ((state[2] = (state[2] + 3) % 4)); }

main() {
	local -A acts=([A]=advance [R]=right [L]=left)
	local -a undir=(north east south west)
	local -A dir=([north]=0 [east]=1 [south]=2 [west]=3)

	state=("${1:-0}" "${2:-0}" "${3:-north}")
	if test -z "${dir[${state[2]}]}"; then die "invalid direction"; fi
	state[2]="${dir[${state[2]}]}"

	for ((i = 0; i < ${#4}; i++)); do
		if test -z "${acts[${4:$i:1}]}"; then die "invalid instruction"; fi
		"${acts[${4:$i:1}]}"
	done

	state[2]="${undir[${state[2]}]}"
	echo "${state[@]}"

}

main "$@"
