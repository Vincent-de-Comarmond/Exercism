BEGIN {
	FS = ","
	split("first,second,third,fourth", weeks, FS)
	split("Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", days, FS)
}

{
	leap_year = leap_year_p($1)
	offset = weekday_offset($1, $2, leap_year)
	num_days_in_month = days_in_month($2, leap_year)
	printf "%04d-%02d-%02d\n", $1, $2, walk_month($3, $4, offset, num_days_in_month)
}


function days_in_month(month, leap_year)
{
	if (month == 2) {
		return (leap_year ? 29 : 28)
	}
	return (month == 4 || month == 6 || month == 9 || month == 11) ? 30 : 31
}

function leap_year_p(year)
{
	if (year % 4 != 0) {
		return 0
	}
	return (year % 400 == 0) ? 1 : (year % 100 == 0) ? 0 : 1
}

function walk_month(week, day, offset, num_days_in_month, _i, _j, _dayname)
{
	_j = 0
	for (_i = 1; _i <= num_days_in_month; _i++) {
		_dayname = days[(offset + _i - 1) % 7 + 1]
		_last[_dayname] = _i
		if (_dayname == day) {
			_j++
			if (weeks[_j] == week || (week == "teenth" && 13 <= _i && _i <= 19)) {
				return _i
			}
		}
	}
	return _last[day]
}

function weekday_offset(year, month, leap_year, _year_diff, _leap_years, _offset, _i)
{
	_year_diff = year - 2018	# Root date where January 1 is on Monday is 2018
	_leap_years = int((_year_diff - 2) / 4)
	_offset = (365 % 7) * (_year_diff - _leap_years) + (366 % 7) * _leap_years
	while (_offset < 0) {
		_offset += 7
	}
	# Day of week offset for first day of target year
	_offset = _offset % 7
	for (_i = 1; _i <= month - 1; _i++) {
		_offset += days_in_month(_i, leap_year)
	}
	# Day of week offset for first day of target month
	return (_offset % 7)
}
