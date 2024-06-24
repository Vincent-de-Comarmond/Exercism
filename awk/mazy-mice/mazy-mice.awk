# These variables are initialized on the command line (using '-v'):
# - Rows
# - Cols
# - Seed (optional)
#
BEGIN {
	rows = 2 * Rows + 1
	columns = 2 * Cols + 1
	previous_seed = (Seed != "") ? srand(Seed) : srand()
	# Special
	characters["right_arrow"] = "\342\207\250"
	characters["cross"] = "\342\224\274"
	# Horizontal
	characters["horizontal"] = "\342\224\200"
	characters["horizontal_up"] = "\342\224\264"
	characters["horizontal_down"] = "\342\224\254"
	# Vertical
	characters["vertical"] = "\342\224\202"
	characters["vertical_right"] = "\342\224\234"
	characters["vertical_left"] = "\342\224\244"
	# Corners
	characters["top_left"] = "\342\224\214"
	characters["top_right"] = "\342\224\220"
	characters["bottom_left"] = "\342\224\224"
	characters["bottom_right"] = "\342\224\230"
	for (r = 0; r < 2 * Rows + 1; r++) {
		for (c = 0; c < 2 * Cols + 1; c++) {
			if (r % 2 == 1 && c % 2 == 1) {
				unvisited[r, c]++
				maze[r, c] = " "
			} else {
				maze[r, c] = "#"
			}
		}
	}
	exit 0	# Skip to end
}

END {
	generate_maze(maze, unvisited)
	pprint_maze(maze)
}


function generate_maze(maze_grid, unvisited_nodes, _visited, _neighbours, _rc, _idx, _rows)
{
	_idx = 1
	split("", _visited, FS)
	_current = random_choice(unvisited_nodes)
	delete unvisited_nodes[_current]
	_visited[_idx] = _current
	while (length(unvisited_nodes) > 0) {
		split(_current, _rc, SUBSEP)
		get_neighbours(_neighbours, unvisited_nodes, _rc[1], _rc[2])
		if (length(_neighbours) > 0) {
			_new = random_choice(_neighbours)
			delete unvisited_nodes[_new]
			_visited[++_idx] = _new
			remove_wall(maze_grid, _current, _new)
			_current = _new
		} else {
			_current = _visited[--_idx]
		}
	}
	# Break out start and end
	for (_idx = 1; _idx < 2 * Rows; _idx++) {
		if (_idx % 2 == 1) {
			_rows[_idx]++
		}
	}
	maze_grid[random_choice(_rows), 0] = characters["right_arrow"]
	maze_grid[random_choice(_rows), 2 * Cols] = characters["right_arrow"]
}

function get_neighbours(result, unvisited_nodes, row, col, _i)
{
	split("", result, FS)
	for (_i = -2; _i <= 2; _i += 2) {
		if ((row + _i, col) in unvisited_nodes) {
			result[row + _i, col]++
		}
	}
	for (_i = -2; _i <= 2; _i += 2) {
		if ((row, col + _i) in unvisited_nodes) {
			result[row, col + _i]++
		}
	}
	delete result[row col]
}

function get_pretty_char(maze_grid, row, col, _i, _j, _tmp)
{
	split("", _tmp, FS)
	for (_i = -1; _i <= 1; _i++) {
		for (_j = -1; _j <= 1; _j++) {
			if (maze_grid[row + _i, col + _j] == "#" || maze_grid[row + _i, col + _j] == characters["right_arrow"]) {
				_tmp[_i, _j]++
			}
		}
	}
	if ((-1, 0) in _tmp && (0, -1) in _tmp && (0, 1) in _tmp && (1, 0) in _tmp) {
		return characters["cross"]
	}
	if ((0, -1) in _tmp && (0, 1) in _tmp) {
		return ((-1, 0) in _tmp) ? characters["horizontal_up"] : ((1, 0) in _tmp) ? characters["horizontal_down"] : characters["horizontal"]
	}
	if ((-1, 0) in _tmp && (1, 0) in _tmp) {
		return ((0, -1) in _tmp) ? characters["vertical_left"] : ((0, 1) in _tmp) ? characters["vertical_right"] : characters["vertical"]
	}
	if ((0, 1) in _tmp) {
		return ((1, 0) in _tmp) ? characters["top_left"] : ((-1, 0) in _tmp) ? characters["bottom_left"] : characters["horizontal"]
	}
	if ((0, -1) in _tmp) {
		return ((1, 0) in _tmp) ? characters["top_right"] : ((-1, 0) in _tmp) ? characters["bottom_right"] : characters["horizontal"]
	}
	return ((1, 0) in _tmp || (-1, 0) in _tmp) ? characters["vertical"] : "#"
}

function pprint_maze(maze_grid, _r, _c, _neighbours, _walls)
{
	for (_r = 0; _r < 2 * Rows + 1; _r++) {
		for (_c = 0; _c < 2 * Cols + 1; _c++) {
			char = maze_grid[_r, _c]
			if (char == "#") {
				char = get_pretty_char(maze_grid, _r, _c)
			}
			printf char
		}
		print ""
	}
}

function random_choice(choices_aarray, _tmp, _n)
{
	_n = asorti(choices_aarray, _tmp)
	return _tmp[1 + int(rand() * _n)]
}

function remove_wall(maze_grid, node1, node2, _tmp1, _tmp2)
{
	split(node1, _tmp1, SUBSEP)
	split(node2, _tmp2, SUBSEP)
	maze_grid[(_tmp1[1] + _tmp2[1]) / 2, (_tmp1[2] + _tmp2[2]) / 2] = " "
}
