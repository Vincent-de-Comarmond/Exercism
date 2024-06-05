{
	for (i = 1; i <= NF; i++) {
		if ($i ~ /^([aeiou]|xr|yt)/) {
			$i = $i "ay"
		} else if ($i ~ /^[^aeiou]*qu/) {
			_tmp = index($i, "qu")
			$i = substr($i, _tmp + 2) substr($i, 1, _tmp + 1) "ay"
		} else if ($i ~ /^[^aeiou]+y/) {
			_tmp = index($i, "y")
			$i = substr($i, _tmp) substr($i, 1, _tmp - 1) "ay"
		} else if ($i ~ /^[^aeiou]+[aeiou]/) {
			_tmp = match($i, /[aeiou]/)
			$i = substr($i, _tmp) substr($i, 1, _tmp - 1) "ay"
		}
	}
	print $0
}

