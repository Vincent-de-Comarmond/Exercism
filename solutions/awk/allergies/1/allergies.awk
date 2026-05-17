BEGIN {
	FS = ","
	split("eggs,peanuts,shellfish,strawberries,tomatoes,chocolate,pollen,cats", allergens, ",")
	for (idx in allergens) {
		allergyscore[allergens[idx]] = 2 ^ (idx - 1)
	}
	# In binary
	# 1, 10, 100, 1000, 10000 .... etc
}

{
	score = $1 % 256
	if ($2 == "allergic_to") {
		component = allergyscore[$3]
		isallergic = and(score, component) ? "true" : "false"
		print isallergic
	} else {
		split("", allergies, FS)
		for (i = length(allergens); i > 0; i--) {
			allergen = allergens[i]
			allergyvalue = allergyscore[allergen]
			if (score >= allergyvalue) {
				score -= allergyvalue
				allergies[allergen] = 1
			}
		}
		ending = length(allergies)
		for (idx in allergens) {
			allergen = allergens[idx]
			if (allergen in allergies) {
				ending -= 1
				tmpstr = (ending > 0) ? sprintf("%s,", allergen) : sprintf("%s\n", allergen)
				printf tmpstr
			}
		}
	}
}

