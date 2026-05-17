#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	echo "This library of functions should be sourced into another script" >&2
	exit 4
fi
bash_version=$((10 * BASH_VERSINFO[0] + BASH_VERSINFO[1]))
if ((bash_version < 43)); then
	echo "This library requires at least bash version 4.3" >&2
	return 4
fi

# Due to inherent bash limitations around word splitting and globbing,
# functions that are intended to *return a list* are instead required to
# receive a nameref parameter, the name of an array variable that will be
# populated in the list function.
# See the filter, map and reverse functions.

# Also note that nameref parameters cannot have the same name as the
# name of the variable in the calling scope.

# Append some elements to the given list.
list::append() {
	local -n __list="$1"
	local el
	for el in "${@:2}"; do __list+=("$el"); done
}

# Return only the list elements that pass the given function.
list::filter() {
	local -n __list="$2" __result="$3"
	local el
	for el in "${__list[@]}"; do if "$1" "$el"; then __result+=("$el"); fi; done
}

# Transform the list elements, using the given function,
# into a new list.
list::map() {
	local -n __list="$2" __result="$3"
	local el tmp
	for el in "${__list[@]}"; do
		read -r tmp < <("$1" "$el")
		__result+=("$tmp")
	done
}

# Left-fold the list using the function and the initial value.
list::foldl() {
	local el accum="$2"
	local -n __list="$3"
	for el in "${__list[@]}"; do accum=$("$1" "$accum" "$el"); done
	echo "$accum"
}

# Right-fold the list using the function and the initial value.
list::foldr() {
	local idx accum="$2"
	local -n __list="$3"
	for ((idx = ${#__list[@]} - 1; idx >= 0; idx--)); do accum=$("$1" "${__list[$idx]}" "$accum"); done
	echo "$accum"
}

# Return the list reversed
list::reverse() {
	local -n __list="$1" __result="$2"
	local idx
	for ((idx = ${#__list[@]} - 1; idx >= 0; idx--)); do __result+=("${__list[$idx]}"); done
}
