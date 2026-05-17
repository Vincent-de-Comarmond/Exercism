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
	} else {
		input = ""
		for (i = 1; i <= NF; i++) {
			input = input $i
		}
		print decode(input)
	}
}


function decode(input, _val, _val2, _val3, _i, _tmp, _tmp2, _result)
{
	_val = ""
	for (_i = 1; _i <= length(input); _i++) {
		_val = _val map[substr(input, _i, 1)]
	}
	# divide into 8 bits
	split("", _tmp, FS)
	for (_i = 1; _i <= length(_val); _i += 8) {
		_tmp[length(_tmp) + 1] = sprintf("%08d", substr(_val, _i, 8))
	}
	_val = ""
	split("", _tmp2, FS)
	for (_i = 1; _i <= length(_tmp); _i++) {
		_val = _val substr(_tmp[_i], 2, 7)
		if (substr(_tmp[_i], 1, 1) == 0) {
			_tmp2[length(_tmp2) + 1] = _val
			_val = ""
		}
	}
	if (_val != "") {
		print("incomplete byte sequence") >> "/dev/stderr"
		exit 1
	}
	_val3 = ""
	for (_i in _tmp2) {
		_result = ""
		_val = reverse(_tmp2[_i])
		for (_j = 1; _j <= length(_val); _j += 4) {
			_val2 = sprintf("%04d", reverse(substr(_val, _j, 4)))
			_result = rev[_val2] _result
		}
		sub(/^0+/, "", _result)
		_result = (_result == "") ? "00" : _result
		_val3 = _val3 " " _result
	}
	sub(/^\s/, "", _val3)
	return _val3
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

function reverse(input_str, __tmp, __i)
{
	__tmp = ""
	for (__i = 1; __i <= length(input_str); __i++) {
		__tmp = substr(input_str, __i, 1) __tmp
	}
	return __tmp
}
