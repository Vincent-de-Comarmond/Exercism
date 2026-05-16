{
	thousands = int($1 / 1000)
	hundreds = int(($1 % 1000) / 100)
	tens = int(($1 % 100) / 10)
	units = $1 % 10
	output = ""
	####################
	# Handle thousands #
	####################
	for (i = 1; i <= thousands; i++) {
		output = output "M"
	}
	###################
	# Handle hundreds #
	###################
	if (hundreds <= 3) {
		for (i = 1; i <= hundreds; i++) {
			output = output "C"
		}
	} else if (hundreds == 4) {
		output = output "CD"
	} else if (hundreds == 9) {
		output = output "CM"
	} else {
		output = output "D"
		for (i = 6; i <= hundreds; i++) {
			output = output "C"
		}
	}
	###############
	# Handle tens #
	###############
	if (tens <= 3) {
		for (i = 1; i <= tens; i++) {
			output = output "X"
		}
	} else if (tens == 4) {
		output = output "XL"
	} else if (tens == 9) {
		output = output "XC"
	} else {
		output = output "L"
		for (i = 6; i <= tens; i++) {
			output = output "X"
		}
	}
	################
	# Handle units #
	################
	if (units <= 3) {
		for (i = 1; i <= units; i++) {
			output = output "I"
		}
	} else if (units == 4) {
		output = output "IV"
	} else if (units == 9) {
		output = output "IX"
	} else {
		output = output "V"
		for (i = 6; i <= units; i++) {
			output = output "I"
		}
	}
	print output
}

