BEGIN {
	transcription["G"] = "C"
	transcription["C"] = "G"
	transcription["T"] = "A"
	transcription["A"] = "U"
}

{
	if (match($1, /[^ACGT]/)) {
		print "Invalid nucleotide detected."
		exit 1
	} else {
		for (i = 1; i <= length($0); i++) {
			printf transcription[substr($1, i, 1)]
		}
		printf "\n"
	}
}

