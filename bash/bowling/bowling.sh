#!/usr/bin/env bash
die() {
	echo "$1" >/dev/stderr && exit 1
}

score() {
	local -n normalized="$1"
	local -i i idx roll1 roll2 next frames score=0 num_rolls="${#normalized[@]}"
	((frames = (num_rolls + 1) / 2))
	###########################
	# Calculate rest of round #
	###########################
	for ((i = 1; i <= 10; i++)); do
		((idx = 2 * i - 2))
		((roll1 = normalized[idx]))
		((roll2 = normalized[idx + 1]))
		((score += roll1 + roll2))

		if ((roll1 + roll2 > 10)); then die "Pin count exceeds pins on the lane"; fi
		if (((i == 10) && (roll1 + roll2 == 10))); then
			if ((frames < 11)); then
				die "Score cannot be taken until the end of the game"
			elif ((frames > 11)); then
				die "Cannot roll after game is over"
			fi
		fi
		if (((i < 10) && (roll1 + roll2 == 10))); then
			((next = normalized[idx + 2]))
			((score += next))
			if ((roll1 == 10)); then
				if ((next == 10)); then ((score += normalized[idx + 4])); else ((score += normalized[idx + 3])); fi
			fi
		fi
	done
	if ((frames < 10)); then die "Score cannot be taken until the end of the game"; fi
	if ((frames > 11)); then die "Cannot roll after game is over"; fi
	##########################
	# Checks for bonus frame #
	##########################
	if ((frames == 11)); then
		if ((normalized[18] == 10)); then
			if ((num_rolls < 22)); then die "Score cannot be taken until the end of the game"; fi
		elif ((normalized[18] + normalized[19] == 10)); then
			if ((num_rolls > 21)); then die "Cannot roll after game is over"; fi
		else
			die "Cannot roll after game is over"
		fi
		((roll1 = normalized[20]))
		((roll2 = ${normalized[21]:-0}))
		if (((roll1 + roll2 > 10) && (roll1 != 10))); then die "Pin count exceeds pins on the lane"; fi
		((score += roll1 + roll2))
	fi

	echo "$score"
}

main() {
	local -a rolls input=("$@")
	local -i parity=0 i=0 frame=1

	for roll in "${input[@]}"; do
		if ((roll < 0)); then die "Negative roll is invalid"; fi
		if ((roll > 10)); then die "Pin count exceeds pins on the lane"; fi

		rolls+=("$roll")
		if (((parity == 0) && (roll == 10))); then
			if ((frame <= 10)); then
				rolls+=(0)
				((frame++))
			fi
		else
			((parity = (parity + 1) % 2))
			(((parity == 0) && frame++))
		fi

		((i++))
	done
	score rolls
}

main "$@"
