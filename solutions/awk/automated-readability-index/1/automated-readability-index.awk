BEGIN {
	RS = "\\.[[:space:]]"
	characters = 0
	word_count = 0
	sentences = 0
	grading[1] = "5-6"
	grading[2] = "6-7"
	grading[3] = "7-8"
	grading[4] = "8-9"
	grading[5] = "9-10"
	grading[6] = "10-11"
	grading[7] = "11-12"
	grading[8] = "12-13"
	grading[9] = "13-14"
	grading[10] = "14-15"
	grading[11] = "15-16"
	grading[12] = "16-17"
	grading[13] = "17-18"
	grading[14] = "18-22"
}

{
	# "Normalize sentences"
	gsub(/\n/, " ", $0)
	gsub(/[[:space:]]+/, " ", $0)
	gsub(/^[[:space:]]/, "", $0)
	gsub(/[[:space:]]$/, "", $0)
	# Ignore empty sentences
	if ($0 !~ /[[:alnum:]]/) {
		next
	}
	sentences++
	# Re-add final full-stop
	$0 = $0 "."
	# Print what's required
	if (NR == 1) {
		print "The text is:"
	}
	if (NR < 4) {
		print (length($0) > 50) ? substr($0, 1, 50) "..." : $0
	} else if (NR == 4) {
		print "..."
	}
	# Do the counts
	for (i = 1; i <= NF; i++) {
		word_count++
		characters += length($i)
	}
}

END {
	score = 4.71 * characters / word_count + 0.5 * word_count / sentences - 21.43
	rounded = (score % 1 < 0.5) ? int(score) : int(score) + 1
	rounded = (rounded < 1) ? 1 : (rounded > 14) ? 14 : rounded
	print ""
	print "Words:", word_count
	print "Sentences:", sentences
	print "Characters:", characters
	printf "Score: %2.2f\n", score
	printf "This text should be understood by %s year-olds.\n", grading[rounded]
}

