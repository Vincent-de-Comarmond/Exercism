#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

validate() {
	local -n preord="$1" inord="$2"
	local -A counts
	local tmp
	if ((${#preord[@]} != ${#inord[@]})); then die "traversals must have the same length"; fi

	for tmp in "${preord[@]}"; do ((counts[$tmp]++)); done
	for tmp in "${counts[@]}"; do if [ "$tmp" -gt 1 ]; then die "traversals must contain unique elements"; fi; done
	counts=()
	for tmp in "${inord[@]}"; do ((counts[$tmp]++)); done
	for tmp in "${counts[@]}"; do if [ "$tmp" -gt 1 ]; then die "traversals must contain unique elements"; fi; done
	for tmp in "${preord[@]}"; do if grep -Eqv "\b$tmp\b" <<<"${inord[*]}"; then die "traversals must have the same elements"; fi; done
}

# printarray() {
# 	local -n array="$1"
# 	local idx
# 	for idx in "${!array[@]}"; do echo "$idx) ${array[$idx]}"; done
# }

getkey() {
	local idx needle="$1"
	local -n haystack="$2"
	for idx in "${!haystack[@]}"; do if [ "$needle" == "${haystack[$idx]}" ]; then echo "$idx" && return; fi; done
	echo "-1"
}

main() {
	local -a preorder inorder
	read -r -a preorder <<<"$1"
	read -r -a inorder <<<"$2"
	validate "preorder" "inorder"
	if [ "${#preorder[@]}" -eq 0 ]; then echo "{}" && return; fi

	local id idx node idx
	local -a tmp l_subtree r_subtree nodes rights lefts

	for id in "${!preorder[@]}"; do
		node="${preorder[$id]}"
		read -r idx < <(getkey "$node" inorder)
		tmp=() && l_subtree=() && r_subtree=()
		for char in "${preorder[@]}"; do if [[ "${inorder[*]:0:$idx}" == *"$char"* ]]; then tmp+=("$char"); fi; done
		for char in "${tmp[@]}"; do if [[ "${preorder[*]:0:$id}" != *"$char"* ]]; then l_subtree+=("$char"); fi; done
		tmp=()
		for char in "${preorder[@]}"; do if [[ "${inorder[*]:$idx+1}" == *"$char"* ]]; then tmp+=("$char"); fi; done
		for char in "${tmp[@]}"; do if [[ "${preorder[*]:0:$id}" != *"$char"* ]]; then r_subtree+=("$char"); fi; done

		nodes+=("$node")
		lefts+=("${l_subtree[0]}")
		rights+=("${r_subtree[0]}")
	done

	# we can't have repeated lefts or rights
	for ((idx = 1; idx < ${#lefts[@]}; idx++)); do
		if [ "${lefts[$idx - 1]}" == "${lefts[$idx]}" ]; then lefts["$idx"]=""; fi
		if [ "${rights[$idx - 1]}" == "${rights[$idx]}" ]; then rights["$idx"]=""; fi
	done

	local -A repr
	for ((idx = ${#nodes[@]} - 1; idx >= 0; idx--)); do
		node="${nodes[$idx]}"
		left="${lefts[$idx]}"
		right="${rights[$idx]}"

		if test -v repr["$left"]; then left="${repr[$left]}"; else left=""; fi
		if test -v repr["$right"]; then right="${repr[$right]}"; else right=""; fi
		repr["$node"]="\"v\": \"$node\", \"l\": {$left}, \"r\": {$right}"
	done
	echo "{${repr[${nodes[0]}]}}"
}

main "$@"
