# Variables declared on the command line
#       start
#       end
BEGIN {
	animals[1] = "fly"
	animals[2] = "spider"
	animals[3] = "bird"
	animals[4] = "cat"
	animals[5] = "dog"
	animals[6] = "goat"
	animals[7] = "cow"
	animals[8] = "horse"
	rhymes[1] = "I don't know why she swallowed the fly. Perhaps she'll die."
	rhymes[2] = "It wriggled and jiggled and tickled inside her."
	rhymes[3] = "How absurd to swallow a bird!"
	rhymes[4] = "Imagine that, to swallow a cat!"
	rhymes[5] = "What a hog, to swallow a dog!"
	rhymes[6] = "Just opened her throat and swallowed a goat!"
	rhymes[7] = "I don't know how she swallowed a cow!"
	rhymes[8] = "She's dead, of course!"
	exit 0
}

END {
	for (i = start; i <= end; i++) {
		song = ""
		song = song sprintf("I know an old lady who swallowed a %s.\n", animals[i])
		song = song sprintf("%s\n", rhymes[i])
		for (j = i; j > 1; j--) {
			if (j == 8) {
				break
			}
			song = song sprintf("She swallowed the %s to catch the %s", animals[j], animals[j - 1])
			if (j == 3) {
				song = song " that" substr(rhymes[2], 3) "\n"
			} else {
				song = song ".\n"
			}
		}
		print (i != 1 && i != 8) ? song rhymes[1] "\n" : song
	}
}

