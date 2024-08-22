#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

Node() {
	if ! test -v idx; then
		declare -ig idx=0
		declare -Ag vertex=() left=() right=()
	fi
	vertex["$idx"]="$1"
	left["$idx"]="$2"
	right["$idx"]="$3"
	echo "v: $1, l: $2, r: $3"
}

validate() {
	local -n preorder="$1" inorder="$2"
	local -a counts
	local tmp
	if ((${#preorder[@]} != ${#inorder[@]})); then die "traversals must have the same length"; fi

	for tmp in "${preorder[@]}"; do ((counts[tmp]++)); done
	for count in "${tmp[@]}"; do if [ "$tmp" -gt 1 ]; then die "traversals must contain unique elements"; fi; done
	counts=()
	for tmp in "${inorder[@]}"; do ((counts[tmp]++)); done
	for tmp in "${counts[@]}"; do if [ "$tmp" -gt 1 ]; then die "traversals must contain unique elements"; fi; done
	for tmp in "${preorder[@]}"; do if grep -Eqv "\b$tmp\b" <<<"${inorder[*]}"; then die "traversals must have the same elements"; fi; done
}

printarray() {
	local -n array="$1"
	local idx
	for idx in "${!array[@]}"; do
		echo "$idx) ${array[$idx]}"
	done
}

getkey() {
	local idx needle="$1"
	local -n haystack="$2"
	for idx in "${!haystack[@]}"; do
		if [ "$needle" == "${haystack[$idx]}" ]; then
			echo "$idx" && return
		fi
	done
	echo "-1"
}

main() {
	local -a inorder passed preorder
	local char idx=0 loc=0 #parent left right
	read -r -a preorder <<<"$1"
	read -r -a inorder <<<"$2"

	topmost="${preorder[0]}"
	read -r idx < <(getkey "$topmost" inorder)
	read -r -a left_subtree < <("${inorder[@]:0:$idx}")
	read -r -a right_subtree < <("${inorder[@]:$((idx + 1))}")

	while ((${#left_subtree[@]}  > 0 || ${#right_subtree[@]} >0 )); do
	    # Node "$topmost" "${left_subtree[-1]}" "${right_subtree[0]}"
	    read -r idx < <(getkey "$topmost" preorder)
	    left="${preorder[$((idx+1))]}"
	    right="${preorder[$((idx+2))]}"

	    
	    

	    
	done
	
	
	

	# read -r idx < <(getkey "$topmost" inorder)
	# if ((idx >= 1)); then left="${inorder[$((idx - 1))]}"; else left=""; fi
	# if ((idx < ${#inorder[@]} - 1)); then right="${inorder[$((idx + 1))]}"; else right=""; fi
	# Node "$topmost" "$left" "$right"

	# while [[ "$left"!="" && "$right"!="" ]]; do
	# 	if [ "$left"!="" ]; then
	# 		topmost="$left"
	# 		read -r idx < <(getkey "$left" inorder)
	# 	else
	# 		topmost="$right"
	# 		read -r idx < <(getkey "$right" inorder)
	# 	fi
	# 	if ((idx >= 1)); then left="${inorder[$((idx - 1))]}"; else left=""; fi
	# 	if ((idx < ${#inorder[@]} - 1)); then right="${inorder[$((idx + 1))]}"; else right=""; fi
	# 	Node "$topmost" "$left" "$right"
	# done

}

main "$@"
