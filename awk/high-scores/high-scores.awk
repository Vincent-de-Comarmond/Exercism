BEGIN {
	split("", scores, FS)
	split("", actions, FS)
}

{
	if ($1 ~ /[0-9]+/) {
		scores[length(scores) + 1] = $1
	} else {
		actions[length(actions) + 1] = $1
	}
}

END {
	for (idx in actions) {
		perform_action(scores, actions[idx])
	}
}


function perform_action(scores, action)
{
	NS = length(scores)
	switch (action) {
	case "list":
		for (idx = 1; idx <= NS; idx++) {
			print scores[idx]
		}
		break
	case "latest":
		print scores[NS]
		break
	case "personalBest":
		asort(scores, copied_scores)
		print copied_scores[NS]
		break
	case "personalTopThree":
		asort(scores, copied_scores)
		stop = (NS >= 3) ? NS - 2 : 1
		for (idx = NS; idx >= stop; idx--) {
			print copied_scores[idx]
		}
	}
}
