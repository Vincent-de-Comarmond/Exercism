BEGIN {
	alphabet = "abcdefghijklmnopqrstuvwxyz"
	srand()
	for (i = 1; i <= length(alphabet); i++) {
		code[i] = substr(alphabet, i, 1)
		code[code[i]] = i
	}
	if (key == "") {
		print make_key()
		exit 0
	}
	if (! (key ~ /^[a-z]+$/)) {
		print("invalid key") > "/dev/stderr"
		exit 1
	}
}

{
	print transcode(tolower($0), key, type)
}


function make_key(_i, _output)
{
	for (_i = 0; _i < 110; _i++) {
		_output = _output code[int(26 * rand())]
	}
	return _output
}

function mod(num, modby, _tmp)
{
	_tmp = num % modby
	return (_tmp <= 0 ? _tmp + modby : _tmp)
}

function transcode(input, key, type, _output, _keylen, _i, _k1, _k2, _trans)
{
	_klen = length(key)
	for (_i = 1; _i <= length(input); _i++) {
		_k1 = code[substr(input, _i, 1)]
		_k2 = code[substr(key, mod(_i, _klen), 1)]
		_trans = type == "encode" ? _k1 + _k2 - 1 : _k1 - _k2 + 1
		_out = _out code[mod(_trans, 26)]
	}
	return _out
}
