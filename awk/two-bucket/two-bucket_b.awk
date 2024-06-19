BEGIN {
	FS = ","
	moves = 0
	litres = 0
	# Volumes
	buckets["one"] = 0
	buckets["two"] = 0
	# Capacities
	capacity["one"] = "TODO"
	capacity["two"] = "TODO"
	# Desired
	desired = "TODO"
	start = "TODO"
}

{
	capacity["one"] = $1
	capacity["two"] = $2
	desired = $3
	start = $4
}


function check_violation(_other)
{
	_other = (start == "one") ? "two" : "one"
	if (buckets[start] == 0 && buckets[_other] == capacity[_other]) {
		return 1
	}
	return 0
}

function empty(bucket)
{
	buckets[bucket] = 0
	check_violation()
}

function fill(bucket)
{
	buckets[bucket] = capacity[bucket]
	check_violation()
}

function transfer(from_bucket, to_bucket, _transfer_capacity)
{
	_transfer_capacity = capacity[to_bucket] - buckets[to_bucket]
	if (buckets[from_bucket] <= _transfer_capacity) {
		buckets[to_bucket] += buckets[from_bucket]
		buckets[from_bucket] = 0
	} else {
		buckets[to_bucket] += _transfer_capacity
		buckets[from_bucket] -= _transfer_capacity
	}
}
