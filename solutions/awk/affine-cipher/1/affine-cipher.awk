BEGIN {
	FS = "|"
	split("abcdefghijklmnopqrstuvwxyz", _tmp, "")
	for (i = 1; i <= length(_tmp); i++) {
		alphabet[_tmp[i]] = i - 1
		alphabet[i - 1] = _tmp[i]
	}
}

/^encode/ {
	coprime_check($2)
	tmp = ""
	for (i = 1; i <= length($4); i++) {
		_in = tolower(substr($4, i, 1))
		if (_in ~ /[a-z]/) {
			oldkey = alphabet[_in]
			tmp = tmp alphabet[($2 * oldkey + $3) % 26]
		}
		if (_in ~ /[0-9]/) {
			tmp = tmp _in
		}
	}
	for (i = 1; i <= length(tmp); i += 5) {
		printf (i == 1) ? "%s" : (i == length(tmp)) ? "%s\n" : " %s", substr(tmp, i, 5)
	}
}

/^decode/ {
	coprime_check($2)
	tmp = ""
	for (i = 1; i <= length($4); i++) {
		_in = tolower(substr($4, i, 1))
		if (_in ~ /[a-z]/) {
			oldkey = alphabet[_in]
			newkey = decrypt($2, $3, oldkey)
			tmp = tmp alphabet[newkey]
		}
		if (_in ~ /[0-9]/) {
			tmp = tmp _in
		}
	}
	print tmp
}


function coprime_check(a, _m, _prime)
{
	_m[2] = 26	# we know this
	_m[13] = 26	# we know this
	for (_prime in _m) {
		if (a % _prime == 0 || _prime % a == 0) {
			print("a and m must be coprime.") >> "/dev/stderr"
			exit 1
		}
	}
}

function decrypt(a, b, y, _mmi, _m, _result)
{
	_mmi = 1
	_m = 26
	while (1) {
		if ((a * _mmi) % _m == 1) {
			break
		}
		_mmi++
	}
	_result = (_mmi * (y - b)) % _m
	# awk allows negative mods
	while (_result < 0) {
		_result += 26
	}
	return _result
}
