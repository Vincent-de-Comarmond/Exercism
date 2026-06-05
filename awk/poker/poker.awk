BEGIN {
	split("", winningnumbers, FS)
	split("", winningsuits, FS)
}

{
	replacebest($1, $2, $3, $4, $5)
}

END {
	for (i in hands) {
		for (j in hands[i]) {
			for (k in hands[i][j]) {
				for (l in hands[i][j][k]) {
					for (m in hands[i][j][k][l]) {
						for (n in hands[i][j][k][l][m]) {
							print i, j, k, l, m, n
						}
					}
				}
			}
		}
	}
}


function add_or_replace_card(idx, card, number, suit)
{
	number = substr(card, 1, length(card) - 1)
	suit = substr(card, length(card) - 1, 1)
	winningnumbers[idx] = number
	winningsuits[idx] = suit
}

function replacebest(c1, c2, c3, c4, c5)
{
	if (length(winninghand) != 5) {
		winninghand[1] = c1
		winninghand[2] = c2
		winninghand[3] = c3
		winninghand[4] = c4
		winninghand[5] = c5
		return
	}
}
