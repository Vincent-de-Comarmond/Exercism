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

printarray() {
	local -n array="$1"
	local idx
	for idx in "${!array[@]}"; do echo "$idx) ${array[$idx]}"; done
}

getkey() {
	local idx needle="$1"
	local -n haystack="$2"
	for idx in "${!haystack[@]}"; do if [ "$needle" == "${haystack[$idx]}" ]; then echo "$idx" && return; fi; done
	echo "-1"
}

getroot() {
	local -n order="$1" subtree="$2"
	local char idx min=1000000000

	for char in "${subtree[@]}"; do
		read -r idx < <(getkey "$char" order)
		if ((0 <= idx && idx < min)); then min="$idx"; fi
	done
	echo "${order[$min]}"
}

main() {
	local -a preorder inorder tmp _subtree left_subtree right_subtree nodes lefts rights
	local node left right
	read -r -a preorder <<<"$1"
	read -r -a inorder <<<"$2"
	validate "preorder" "inorder"

	for node in "${preorder[@]}"; do

		echo "Nodes: ${nodes[@]}"
		echo "Left ($left) idx in nodes: $idx"
		echo "Right ($right) idx in nodes: $idx"
		echo "Node: $node"
		read -r idx < <(getkey "$node" inorder)
		read -r -a tmp <<<"${inorder[@]:0:$idx}"
		echo "tmp: ${tmp[@]}"
		readarray -t _subtree < <(
		    for char in "${tmp[@]}"; do if [[ "${nodes[*]}" != *"$char"* ]]; then echo "$char"; fi; done
		)
		echo "Left subtree: ${_subtree[@]}"
		case "${#_subtree[@]}" in
		0) left="#" ;;
		1) left="${_subtree[0]}" ;;
		*) read -r left < <(getroot preorder _subtree) ;;
		esac
		echo "left: $left"

		read -r -a tmp <<<"${inorder[@]:$idx+1}"
		echo "tmp: ${tmp[@]}"
		readarray -t _subtree < <(
			for char in "${tmp[@]}"; do if [[ "${nodes[*]}" != *"$char"* ]]; then echo "$char"; fi; done
		)
		echo "Right subtree: ${_subtree[@]}"
		case "${#_subtree[@]}" in
		0) right="#" ;;
		1) right="${_subtree[0]}" ;;
		*) read -r right < <(getroot preorder _subtree) ;;
		esac
		echo "right: $right"

		read -r idx < <(getkey "$left" nodes)
		if [ "$idx" -ne -1 ]; then left="#"; fi
		read -r idx < <(getkey "$right" nodes)
		if [ "$idx" -ne -1 ]; then right="#"; fi
		echo "#######"

		nodes+=("$node")
		lefts+=("$left")
		rights+=("$right")
	done

	echo "Nodes"
	printarray nodes
	echo "Lefts"
	printarray lefts
	echo "Rights"
	printarray rights
}

main "$@"
