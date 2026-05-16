#!/usr/bin/env bash
main() {
	local -i i
	local -a allergies allergens=(
		"eggs" "peanuts" "shellfish" "strawberries"
		"tomatoes" "chocolate" "pollen" "cats")

	for ((i = 0; i < ${#allergens[@]}; i++)); do
		if (($1 & (2 ** i))) && test -v; then
			allergies+=("${allergens[$i]}")
		fi
	done

	if [ "$2" == "allergic_to" ]; then
		if grep -qE "\b$3\b" <<<"${allergies[@]}"; then
			echo "true"
		else
			echo "false"
		fi
	elif [ "$2" == "list" ]; then
		echo "${allergies[@]}"
	fi
}
main "$@"
