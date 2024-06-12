BEGIN {
	numbers[80] = "eighty"
	numbers[50] = "fifty"
	numbers[40] = "forty"
	numbers[30] = "thirty"
	numbers[20] = "twenty"
	numbers[19] = "nineteen"
	numbers[18] = "eighteen"
	numbers[17] = "seventeen"
	numbers[16] = "sixteen"
	numbers[15] = "fifteen"
	numbers[14] = "fourteen"
	numbers[13] = "thirteen"
	numbers[12] = "twelve"
	numbers[11] = "eleven"
	numbers[10] = "ten"
	numbers[9] = "nine"
	numbers[8] = "eight"
	numbers[7] = "seven"
	numbers[6] = "six"
	numbers[5] = "five"
	numbers[4] = "four"
	numbers[3] = "three"
	numbers[2] = "two"
	numbers[1] = "one"
	numbers[0] = "zero"
}

/^[0-9]{1,12}$/ {
	if ($0 == 0) {
		print numbers[$0]
	}
	billions = int($0 / 10 ^ 9)
	millions = int(($0 % 10 ^ 9) / 10 ^ 6)
	thousands = int(($0 % 10 ^ 6) / 10 ^ 3)
	tmp = ""
	if (billions > 0) {
		tmp = handle_hundreds(billions) " billion "
	}
	if (millions > 0) {
		tmp = tmp handle_hundreds(millions) " million "
	}
	if (thousands > 0) {
		tmp = tmp handle_hundreds(thousands) " thousand "
	}
	if ($0 % 1000 > 0) {
		tmp = tmp handle_hundreds($0 % 1000)
	}
	sub(/^\s/, "", tmp)
	sub(/\s$/, "", tmp)
	print tmp
	next
}

{
	print("input out of range") >> "/dev/stderr"
	exit 1
}


function handle_hundreds(num, _h, _tt, _t, _u, _tail)
{
	_h = int((num % 1000) / 100)
	_tt = num % 100
	_u = _tt % 10
	_t = (_tt - _u) / 10
	_t = (_t * 10 in numbers) ? numbers[_t * 10] : numbers[_t] "ty"
	_tail = (_tt <= 20) ? numbers[_tt] : (_u > 0) ? _t "-" numbers[_u] : _t
	if (_h == 0) {
		return _tail
	}
	if (_tt > 0) {
		return (numbers[_h] " hundred " _tail)
	}
	return (numbers[_h] " hundred")
}
