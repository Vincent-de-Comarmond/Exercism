BEGIN {
	current_frame = 1 SUBSEP 1
	complete = 0
	split("", linear, FS)
}

/^([0-9]|10)( [0-9]| 10){11,21}$/ {
	for (i = 1; i <= NF; i++) {
		roll($i)
	}
	if (! (complete)) {
		print("Score cannot be taken until the end of the game") >> "/dev/stderr"
		exit 1
	}
	print score()
	next
}

{
	if ($0 ~ /-/) {
		print("Negative roll is invalid") >> "/dev/stderr"
	} else if ($0 ~ /[1-9][1-9]/) {
		print("Pin count exceeds pins on the lane") >> "/dev/stderr"
	} else if ($0 ~ /2 9|3 8|4 7|5 6|6 5|7 4|8 3|9 2/) {
		print("Pin count exceeds pins on the lane") >> "/dev/stderr"
	} else {
		print("Score cannot be taken until the end of the game") >> "/dev/stderr"
	}
	exit 1
}

END {
	if (NR == 0) {
		print("Score cannot be taken until the end of the game") >> "/dev/stderr"
		exit 1
	}
}


function roll(pins)
{
	if (complete) {
		print("Cannot roll after game is over") > "/dev/stderr"
		exit 1
	}
	linear[length(linear) + 1] = current_frame
	split(current_frame, tmp, SUBSEP)
	frames[current_frame] = pins
	if (tmp[1] == 10) {
		if (tmp[2] == 1) {
			current_frame = tmp[1] SUBSEP 2
		}
		if (tmp[2] == 2) {
			if ((pins + frames[10, 1]) >= 10) {
				current_frame = tmp[1] SUBSEP 3
			} else {
				complete = 1
			}
		}
		if (tmp[2] == 3) {
			if (frames[10, 1] == 10 && frames[10, 2] < 10 && frames[10, 2] + pins > 10) {
				print("Pin count exceeds pins on the lane") >> "/dev/stderr"
				exit 1
			}
			complete = 1
		}
		return
	}
	if (tmp[2] == 1 && pins == 10) {
		current_frame = (tmp[1] + 1) SUBSEP 1
		return
	}
	if (tmp[2] == 1) {
		current_frame = tmp[1] SUBSEP 2
	} else {
		current_frame = (tmp[1] + 1) SUBSEP 1
	}
	return
}

function score(_score, _idx)
{
	_score = 0
	for (_idx = 1; _idx <= length(linear); _idx++) {
		split(linear[_idx], _tmp, SUBSEP)
		_score += frames[linear[_idx]]
		if (_tmp[1] < 10) {
			if (_tmp[2] == 1 && frames[linear[_idx]] == 10) {
				_score += frames[linear[_idx + 1]] + frames[linear[_idx + 2]]
			}
			if (_tmp[2] == 2) {
				if (frames[linear[_idx - 1]] + frames[linear[_idx]] == 10) {
					_score += frames[linear[_idx + 1]]
				}
				if (frames[linear[_idx - 1]] + frames[linear[_idx]] > 10) {
					print("Pin count exceeds pins on the lane") >> "/dev/stderr"
					exit 1
				}
			}
		}
	}
	return _score
}
