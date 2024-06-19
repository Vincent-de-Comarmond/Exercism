BEGIN {
	FS = ","
	OFS = ","
}

{
	capacity[1] = $1
	capacity[2] = $2
	target = $3
	if (target > $1 && target > $2) {
		print("invalid goal") >> "/dev/stderr"
		exit 1
	}
	if (target % gcd($1, $2) != 0) {
		print("invalid goal") >> "/dev/stderr"
		exit 1
	}
	start = ($4 == "one") ? 1 : 2
	state = ($4 == "one") ? capacity[1] SUBSEP 0 SUBSEP 1 : 0 SUBSEP capacity[2] SUBSEP 1
	states[state] = 1
	solution = solve(states)
	split(solution, b1_b2_actions, SUBSEP)
	actions = b1_b2_actions[3]
	bucket = (b1_b2_actions[1] == target) ? "one" : "two"
	other = (bucket == "one") ? b1_b2_actions[2] : b1_b2_actions[1]
	print actions, bucket, other
}


function check_valid(proposed_state, _tmp)
{
	split(proposed_state, _tmp, SUBSEP)
	_other = (start == 1) ? 2 : 1
	if (_tmp[start] == 0 && _tmp[_other] == capacity[_other]) {
		return 0
	}
	return 1
}

function empty_1(input_state, _proposed_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	_proposed_state = 0 SUBSEP _tmp[2] SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}

function empty_2(input_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	_proposed_state = _tmp[1] SUBSEP 0 SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}

function fill_1(input_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	_proposed_state = capacity[1] SUBSEP _tmp[2] SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}

function fill_2(input_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	_proposed_state = _tmp[1] SUBSEP capacity[2] SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}

function finished(input_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	if (_tmp[1] == target || _tmp[2] == target) {
		return 1
	}
	return 0
}

function gcd(bucket1_cap, bucket2_cap, _primes, _min, _current, _idx, _prime_p)
{
	_primes[1] = 2
	_primes[2] = 3
	_min = (bucket2_cap < bucket1_cap) ? bucket2_cap : bucket1_cap
	_current = _primes[length(_primes)]
	while (_current < int(sqrt(_min))) {
		_current += 2
		_prime_p = 1
		for (_idx = 1; _idx <= length(_primes); _idx++) {
			if (_current % _primes[_idx] == 0) {
				_prime_p = 0
				break
			}
			if (_prime_p) {
				_primes[length(_primes) + 1] = _current
			}
		}
	}
	_min = 1	# _min is now gcd
	for (_idx = 1; _idx <= length(_primes); _idx++) {
		if (bucket1_cap % _primes[_idx] == 0 && bucket2_cap % _primes[_idx] == 0) {
			_min = (_primes[_idx] > _min) ? _primes[_idx] : _min
		}
	}
	return _min
}

function solve(state_stack, _functions, _idx, _function, _state)
{
	split("", _functions, FS)
	_functions[length(_functions) + 1] = "empty_1"
	_functions[length(_functions) + 1] = "empty_2"
	_functions[length(_functions) + 1] = "fill_1"
	_functions[length(_functions) + 1] = "fill_2"
	_functions[length(_functions) + 1] = "fill_2"
	_functions[length(_functions) + 1] = "transfer_12"
	_functions[length(_functions) + 1] = "transfer_21"
	while (1) {
		for (_state in state_stack) {
			if (finished(_state)) {
				return _state
			}
			for (_idx in _functions) {
				_function = _functions[_idx]
				proposed_state = @_function(_state)
				if (proposed_state != "") {
					if (finished(proposed_state)) {
						return proposed_state
					}
					state_stack[proposed_state] = 1
				}
				delete state_stack[_state]
			}
		}
	}
}

function transfer_12(input_state, _tmp, _transfer_capacity, _proposed_state)
{
	split(input_state, _tmp, SUBSEP)
	_transfer_capacity = capacity[2] - _tmp[2]
	if (_tmp[1] <= _transfer_capacity) {
		_tmp[2] += _tmp[1]
		_tmp[1] = 0
	} else {
		_tmp[1] -= _transfer_capacity
		_tmp[2] = capacity[2]
	}
	_proposed_state = _tmp[1] SUBSEP _tmp[2] SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}

function transfer_21(input_state, _tmp)
{
	split(input_state, _tmp, SUBSEP)
	_transfer_capacity = capacity[1] - _tmp[1]
	if (_tmp[2] <= _transfer_capacity) {
		_tmp[1] += _tmp[2]
		_tmp[2] = 0
	} else {
		_tmp[2] -= _transfer_capacity
		_tmp[1] = capacity[1]
	}
	_proposed_state = _tmp[1] SUBSEP _tmp[2] SUBSEP (_tmp[3] + 1)
	if (check_valid(_proposed_state)) {
		return _proposed_state
	}
}
