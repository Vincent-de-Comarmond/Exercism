BEGIN {
	split("", reflectors, FS)
	x0 = 0
	y0 = 0
	theta0 = 0
}

{
	if (NF == 3) {
		x0 = $1
		y0 = $2
		theta0 = $3
	} else {
		reflectors[$1] = $2 SUBSEP $3 SUBSEP $4
	}
}

END {
	split("", points, FS)
	populate_trajectory(points, reflectors, x0, y0, theta0)
	for (i = 1; i <= length(points); i++) {
		printf "%s%d", i == 1 ? "" : " ", points[i]
	}
}


function approx_eq(alpha, beta, tol)
{
	return (alpha < beta ? (beta - alpha) <= tol : (alpha - beta) <= tol)
}

function cosdeg(angle)
{
	return cos(angle * atan2(0, -1) / 180)
}

function euclid2(x1, y1, x2, y2)
{
	return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
}

function populate_trajectory(reflectors_hit, reflector_map, x, y, theta, _i, _a, _eps, _tmp, _dist, _min_dist)
{
	_tmp[1] = 0
	_min_dist = -1
	_costheta = cosdeg(theta)
	_sintheta = sindeg(theta)
	_eps = 1e-3
	for (_i in reflector_map) {
		split(reflector_map[_i], _a, SUBSEP)	# defines _a
		# Don't self-reflect
		if (approx_eq(_a[1], x, _eps) && approx_eq(_a[2], y, _eps)) {
			continue
		}
		_dist = euclid2(_a[1], x, _a[2], y)
		# Vertical
		if (approx_eq(x, _a[1], _eps) && approx_eq(_costheta, 0, _eps)) {
			if ((y < _a[2]) == (0 < _sintheta)) {
				if ((_min_dist < 0) || (_dist < _min_dist)) {
					_tmp[1] = _a[1]
					_tmp[2] = _a[2]
					_tmp[3] = _a[3]
					_tmp[4] = _i
					_min_dist = _dist
				}
				continue
			}
		}
		# Horizontal
		if (approx_eq(y, _a[2], _eps) && approx_eq(_sintheta, 0, _eps)) {
			if ((x < _a[1]) == (0 < _costheta)) {
				if ((_min_dist < 0) || (_dist < _min_dist)) {
					_tmp[1] = _a[1]
					_tmp[2] = _a[2]
					_tmp[3] = _a[3]
					_tmp[4] = _i
					_min_dist = _dist
				}
				continue
			}
		}
		if (approx_eq(_costheta, 0, _eps) || approx_eq(_sintheta, 0, _eps)) {
			continue
		}
		if (0 == 1) {
			print "======================="
			print reflectors_hit[length(reflectors_hit)]
			print _i, (_a[1] - x) * _sintheta, "==", (_a[2] - y) * _costheta
			print (_a[1] - x) * _costheta, (_a[2] - y) * _sintheta
			print _dist
			print "======================="
		}
		# Angle
		if (approx_eq((_a[1] - x) * _sintheta, (_a[2] - y) * _costheta, _eps)) {
			# Check dot procut if dx, dy align with [cos(theta), sin(theta)]
			if (0 < (_a[1] - x) * _costheta + (_a[2] - y) * _sintheta) {
				if ((_min_dist < 0) || (_dist < _min_dist)) {
					_tmp[1] = _a[1]
					_tmp[2] = _a[2]
					_tmp[3] = _a[3]
					_tmp[4] = _i
					_min_dist = _dist
				}
				continue
			}
		}
	}
	if (0 < _min_dist) {
		reflectors_hit[length(reflectors_hit) + 1] = _tmp[4]
		return populate_trajectory(reflectors_hit, reflector_map, _tmp[1], _tmp[2], _tmp[3] + theta)
	}
}

function sindeg(angle)
{
	return sin(angle * atan2(0, -1) / 180)
}
