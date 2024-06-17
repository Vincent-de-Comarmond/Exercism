# These variables are initialized on the command line (using '-v'):
# - value
BEGIN {
	FS = ","
	split("", songs, FS)
}

{
	for (i = 1; i <= NF; i++) {
		songs[i] = $i
	}
	print bin_search(songs, value, 1, length(songs))
}


function bin_search(list, search_v, begin, end, _idx, _v)
{
	_idx = int((begin + end) / 2)
	_v = list[_idx]
	if (_v == search_v) {
		return int(_idx)
	}
	if (begin == end) {
		return -1
	}
	begin = (search_v > _v) ? _idx + (_idx == begin) : begin
	end = (search_v > _v) ? end : _idx
	return bin_search(list, search_v, begin, end)
}
