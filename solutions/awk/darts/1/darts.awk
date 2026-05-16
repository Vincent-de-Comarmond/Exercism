BEGIN {
	split("1 25 100", radii, FS)
	radius_squared[100] = 1
	radius_squared[25] = 5
	radius_squared[1] = 10
}

{
	dist_sq = $1 ^ 2 + $2 ^ 2
	for (i in radii) {
		ring = radii[i]
		if (dist_sq + 0 <= ring + 0) {
			print radius_squared[ring]
			next
		}
	}
	print "0"
}

