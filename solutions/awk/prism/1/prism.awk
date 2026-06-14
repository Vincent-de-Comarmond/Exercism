BEGIN {
	split("", reflectors, FS)
	split("", point, FS)
	split("", points, FS)
}

NF == 3 {
	point[1] = $1
	point[2] = $2
	point[3] = $3
	next
}

{
	reflectors[$1] = $2 SUBSEP $3 SUBSEP $4
}

END {
	populate_trajectory(points, reflectors, point)
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

function populate_trajectory(reflectors_hit, reflector_map, current, _cos, _sin, _i, _point, _nextpoint, _eps, _mindist, _dist, _idx)
{
	_idx = 0
	_eps = 1e-2
	_mindist = 1e10
	_cos = cosdeg(current[3])
	_sin = sindeg(current[3])
	#############################################################
	# So we have x = x0 + rcos(ϑ), y = y0 + rsin(ϑ)	    #
	# direction vector is [cos(ϑ), sin(ϑ)]			    #
	# for perpendicular dot product must be 0:		    #
	# [-sin(ϑ), cos(ϑ)]					    #
	# Additionally next point is x1, y1, so:		    #
	# x = x1 -dsin(ϑ), y= y1 + dcos(ϑ).			    #
	# d is distance. If 0 check that r is positive. Done	    #
	#############################################################
	# x0 + rcos(ϑ) = x1 -dsin(ϑ), y0 + rsin(ϑ) = y1 + dcos(ϑ)
	# r = (x1 - x0 -dsin(ϑ)) / cos(ϑ)
	# =   (y1 - y0 +dcos(ϑ)) / sin(ϑ)
	# (x1 - x0) sin(ϑ) - d sin(ϑ) sin(ϑ) = (y1 - y0) cos(ϑ) + d cos(ϑ) cos(ϑ)
	# (x1 - x0) sin(ϑ) - (y1 - y0) cos(ϑ) = d
	# x0  + rcos(ϑ) - x1 = -d sin(ϑ)
	# (x1 - x0 - rcos(ϑ)) / sin(ϑ) = d = (y0 - y1 +rsin(ϑ)) / cos(ϑ)
	# (x1 - x0) cos(ϑ) - r cos(ϑ) cos(ϑ) = (y0 - y1)sin(ϑ) + r sin(ϑ) sin(ϑ)
	# (x1 - x0) cos(ϑ) + (y1 - y0)sin(ϑ) = r
	for (_i in reflector_map) {
		if ((0 < length(reflectors_hit)) && _i == reflectors_hit[length(reflectors_hit)]) {
			continue
		}
		split(reflector_map[_i], _point, SUBSEP)
		_dist = (_point[1] - current[1]) * _sin - (_point[2] - current[2]) * _cos
		if (approx_eq(_dist, 0, _eps)) {
			_dist = (_point[1] - current[1]) * _cos + (_point[2] - current[2]) * _sin
			if (0 < _dist && _dist < _mindist) {
				_idx = _i
				_mindist = _dist
				_nextpoint[1] = _point[1]
				_nextpoint[2] = _point[2]
				_nextpoint[3] = _point[3] + current[3]
			}
		}
	}
	if (_idx != 0) {
		reflectors_hit[length(reflectors_hit) + 1] = _idx
		return populate_trajectory(reflectors_hit, reflector_map, _nextpoint)
	}
}

function sindeg(angle)
{
	return sin(angle * atan2(0, -1) / 180)
}
