#!/usr/bin/env bash
main() {
	local space_age
	local -A planet_years=(
		["Mercury"]=0.2408467
		["Venus"]=0.61519726
		["Earth"]=1.0
		["Mars"]=1.8808158
		["Jupiter"]=11.862615
		["Saturn"]=29.447498
		["Uranus"]=84.016846
		["Neptune"]=164.79132
	)
	if test ! -v "planet_years[$1]"; then
		echo "not a planet" && exit 1
	fi

	space_age=$(
		bc -l <<-EOF
			earth_secs=365.25*24*60*60
			planet_secs=earth_secs*${planet_years[$1]}
			print $2/planet_secs
		EOF
	)
	printf "%.2f" "$space_age"
}
main "$@"
