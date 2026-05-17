BEGIN {
	FS = ","
}

{
	split($6, operations, " ")
	operation = operations[1]
	print @operation($1, $2, $3, $4, $5)
}


function big(a, b, c, d, e, _tmp, _key)
{
	split("", _tmp, FS)
	_tmp[a]++
	_tmp[b]++
	_tmp[c]++
	_tmp[d]++
	_tmp[e]++
	asorti(_tmp)
	# If 5 then 1->2,2->3,3->4,4->5,5->6, if 6 1->1, 2->2, 3->3, 4->4, 5->5, 6->6
	# In either case, uniquely, lenth - 4 = 2
	return (_tmp[length(_tmp) - 4] == 2) ? 30 : 0
}

function choice(a, b, c, d, e)
{
	return (a + b + c + +d + e)
}

function fives(a, b, c, d, e)
{
	return (5 * ((a == 5) + (b == 5) + (c == 5) + (d == 5) + (e == 5)))
}

function four(a, b, c, d, e, _tmp, _key)
{
	split("", _tmp, FS)
	_tmp[a]++
	_tmp[b]++
	_tmp[c]++
	_tmp[d]++
	_tmp[e]++
	for (_key in _tmp) {
		if (_tmp[_key] >= 4) {
			return (4 * _key)
		}
	}
	return 0
}

function fours(a, b, c, d, e)
{
	return (4 * ((a == 4) + (b == 4) + (c == 4) + (d == 4) + (e == 4)))
}

function full(a, b, c, d, e, _tmp)
{
	split("", _tmp, FS)
	_tmp[a]++
	_tmp[b]++
	_tmp[c]++
	_tmp[d]++
	_tmp[e]++
	asort(_tmp)
	return (length(_tmp) == 2 && _tmp[1] == 2 && _tmp[2] == 3) ? (a + b + c + d + e) : 0
}

function little(a, b, c, d, e, _tmp)
{
	split("", _tmp, FS)
	_tmp[a]++
	_tmp[b]++
	_tmp[c]++
	_tmp[d]++
	_tmp[e]++
	asorti(_tmp)
	return (_tmp[5] == 5) ? 30 : 0
}

function ones(a, b, c, d, e)
{
	return (a == 1) + (b == 1) + (c == 1) + (d == 1) + (e == 1)
}

function sixes(a, b, c, d, e)
{
	return (6 * ((a == 6) + (b == 6) + (c == 6) + (d == 6) + (e == 6)))
}

function threes(a, b, c, d, e)
{
	return (3 * ((a == 3) + (b == 3) + (c == 3) + (d == 3) + (e == 3)))
}

function twos(a, b, c, d, e)
{
	return (2 * ((a == 2) + (b == 2) + (c == 2) + (d == 2) + (e == 2)))
}

function yacht(a, b, c, d, e)
{
	if (a == b && b == c && c == d && d == e) {
		return 50
	}
	return 0
}
