BEGIN {
	instruction["AUG"] = "Methionine"
	instruction["UUU"] = "Phenylalanine"
	instruction["UUC"] = "Phenylalanine"
	instruction["UUA"] = "Leucine"
	instruction["UUG"] = "Leucine"
	instruction["UCU"] = "Serine"
	instruction["UCC"] = "Serine"
	instruction["UCA"] = "Serine"
	instruction["UCG"] = "Serine"
	instruction["UAU"] = "Tyrosine"
	instruction["UAC"] = "Tyrosine"
	instruction["UGU"] = "Cysteine"
	instruction["UGC"] = "Cysteine"
	instruction["UGG"] = "Tryptophan"
	instruction["UAA"] = "STOP"
	instruction["UAG"] = "STOP"
	instruction["UGA"] = "STOP"
}

{
	split("", proteins, FS)
	for (i = 1; i <= length($0); i += 3) {
		rna = substr($0, i, 3)
		if (rna in instruction) {
			protein = instruction[rna]
			if (protein == "STOP") {
				break
			}
			proteins[length(proteins) + 1] = protein
		} else {
			print("Invalid codon") > "/dev/stderr"
			exit 1
		}
	}
	for (i in proteins) {
		printf (i == 1) ? "%s" : " %s", proteins[i]
	}
}

