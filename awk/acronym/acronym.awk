{
	sub("-", " ", $0)
	$0 = toupper($0)
	gsub(/[^A-Z ]/, "", $0)
	for (i = 1; i <= NF; i++) {
		printf substr($i, 1, 1)
	}
	printf "\n"
}

