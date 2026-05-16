BEGIN {
	# This
	these[1] = "house"
	these[2] = "malt"
	these[3] = "rat"
	these[4] = "cat"
	these[5] = "dog"
	these[6] = "cow with the crumpled horn"
	these[7] = "maiden all forlorn"
	these[8] = "man all tattered and torn"
	these[9] = "priest all shaven and shorn"
	these[10] = "rooster that crowed in the morn"
	these[11] = "farmer sowing his corn"
	these[12] = "horse and the hound and the horn"
	# That
	thatdo[1] = "Jack built."
	thatdo[2] = "lay in"
	thatdo[3] = "ate"
	thatdo[4] = "killed"
	thatdo[5] = "worried"
	thatdo[6] = "tossed"
	thatdo[7] = "milked"
	thatdo[8] = "kissed"
	thatdo[9] = "married"
	thatdo[10] = "woke"
	thatdo[11] = "kept"
	thatdo[12] = "belonged to"
	# Play song
	if (1 <= start && end <= 12 && start <= end) {
		play_verses(start, end)
	} else {
		print("invalid") > "/dev/stderr"
		exit 1
	}
}

function play_verse(verse_number, _i, _verse)
{
	_i = verse_number
	for (_i = verse_number; 1 <= _i; _i--) {
		_verse = sprintf("%s the %s that %s", _verse, these[_i], thatdo[_i])
	}
	return ("This is" _verse)
}

function play_verses(start_at, end_at, _j)
{
	for (_j = start_at; _j <= end_at; _j++) {
		print play_verse(_j)
	}
}
