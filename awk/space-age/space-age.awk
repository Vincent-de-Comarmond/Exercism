BEGIN {
	YEAR = 365.25 * 24 * 60 * 60
	planets["Mercury"] = 0.2408467 * YEAR
	planets["Venus"] = 0.61519726 * YEAR
	planets["Earth"] = 1.0 * YEAR
	planets["Mars"] = 1.8808158 * YEAR
	planets["Jupiter"] = 11.862615 * YEAR
	planets["Saturn"] = 29.447498 * YEAR
	planets["Uranus"] = 84.016846 * YEAR
	planets["Neptune"] = 164.79132 * YEAR
}

{
	if ($1 in planets) {
		printf "%1.2f", ($2 / planets[$1])
	} else {
		print "not a planet"
		exit 1
	}
}

