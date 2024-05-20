# These variables are initialized on the command line (using '-v'):
# - verse
# - start
# - stop
BEGIN {
	if (verse != "" && start == "" && stop == "") {
		print_verse(verse)
	} else if (start != "" && stop != "" && verse == "") {
		for (i = start; i >= stop; i--) {
			print_verse(i)
		}
	} else {
		exit 1
	}
}


function print_verse(verse_number)
{
	if (verse_number == 0) {
		print "No more bottles of beer on the wall, no more bottles of beer."
		print "Go to the store and buy some more, 99 bottles of beer on the wall."
	}
	if (verse_number == 1) {
		print "1 bottle of beer on the wall, 1 bottle of beer."
		print "Take it down and pass it around, no more bottles of beer on the wall."
	}
	if (verse_number == 2) {
		print "2 bottles of beer on the wall, 2 bottles of beer."
		print "Take one down and pass it around, 1 bottle of beer on the wall."
	}
	if (verse_number > 2) {
		printf "%s bottles of beer on the wall, %s bottles of beer.\n", verse_number, verse_number
		printf "Take one down and pass it around, %s bottles of beer on the wall.\n", verse_number - 1
	}
}
