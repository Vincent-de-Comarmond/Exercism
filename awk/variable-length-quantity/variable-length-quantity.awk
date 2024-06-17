# These variables are initialized on the command line (using '-v'):
# - action
BEGIN {
	map["0"] = "0000"
	map["1"] = "0001"
	map["2"] = "0010"
	map["3"] = "0011"
	map["4"] = "0100"
	map["5"] = "0101"
	map["6"] = "0110"
	map["7"] = "0111"
	map["8"] = "1000"
	map["9"] = "1001"
	map["A"] = "1010"
	map["B"] = "1011"
	map["C"] = "1100"
	map["D"] = "1101"
	map["E"] = "1110"
	map["F"] = "1111"
	for (i in map) {
		rev[map[i]] = i
	}
}

{
	if (action != "encode" && action != "decode") {
		print("unknown action") >> "/dev/stderr"
		exit 1
	}
	if (action == "encode") {
		result = ""
		for (i = 1; i <= NF; i++) {
			result = (i == 1) ? encode($1) : result " " encode($i)
		}
		print result
	}
}


function decode(input)
{
}

function encode(input, _tmp, _i, _val, _val2, _min, _max)
{
	split("", _tmp, FS)
	binary = hex2bin(input)
	for (_i = length(binary); _i >= 1; _i -= 7) {
		_min = (_i > 6) ? _i - 6 : 1
		_max = (_i > 6) ? 7 : _i
		_tmp[length(_tmp) + 1] = sprintf("%07d", substr(binary, _min, _max))
	}
	_val = ""
	for (_i = length(_tmp); _i >= 1; _i--) {
		_min = sprintf("0%07d", _tmp[_i])
		_max = sprintf("1%07d", _tmp[_i])
		if (length(_val) > 0) {
			_val = _val ((_i == 1) ? _min : _max)
		} else {
			_val = (_tmp[_i] + 0 == 0 || length(_tmp) == 1) ? _min : _max
		}
	}
	_val2 = ""
	for (_i = 1; _i <= length(_val); _i += 4) {
		_val2 = _val2 rev[substr(_val, _i, 4)]
	}
	_val = ""
	sub(/^0+/, "", _val2)
	_val2 = (length(_val2) == 0) ? "00" : _val2
	for (_i = 1; _i <= length(_val2); _i += 2) {
		_val = (_i == 1) ? substr(_val2, _i, 2) : _val " " substr(_val2, _i, 2)
	}
	return _val
}

function hex2bin(input, _i, _tmp)
{
	_tmp = ""
	for (_i = 1; _i <= length(input); _i++ 0) {
		_tmp = _tmp map[substr(input, _i, 1)]
	}
	return _tmp
}
