/create/ {
	normalized = normalize_mintes($2, $3)
	printf "%02d:%02d\n", int(normalized / 60), normalized % 60
}

/add/ {
	normalized = normalize_mintes($2, $3 + $4)
	printf "%02d:%02d\n", int(normalized / 60), normalized % 60
}

/subtract/ {
	normalized = normalize_mintes($2, $3 - $4)
	printf "%02d:%02d\n", int(normalized / 60), normalized % 60
}

/equal/ {
	equal = normalize_mintes($2, $3) == normalize_mintes($4, $5)
	print equal ? "true" : "false"
}

function normalize_mintes(hours, minutes, _normalized)
{
	_normalized = (60 * hours + minutes) % (24 * 60)
	_normalized += _normalized < 0 ? (24 * 60) : 0
	return _normalized
}
