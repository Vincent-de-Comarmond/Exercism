BEGIN {
	split("+ - * / swap over", _tmp, FS)
	for (i = 1; i <= length(_tmp); i++) {
		bivariate_ops[_tmp[i]] = 1
	}
	univariate_ops["dup"] = 1
	univariate_ops["drop"] = 1
}

FNR == 1 {
	split("", macro_order, FS)
	split("", macro_defs, FS)
	split("", stack, FS)
}

/^:.*$/ {
	$0 = tolower($0)
	if ($NF != ";") {
		bail("macro not terminated with semicolon")
	}
	if (NF < 4) {
		bail("empty macro definition")
	}
	if ($2 !~ /([a-z]|-|+|*|\/)+/ || $2 ~ /-?[0-9]+/) {
		bail("illegal operation")
	}
	for (i = 3; i <= NF - 1; i++) {
		rest = (i == 3) ? $i : rest " " $i
	}
	for (i = 1; i <= length(macro_order); i++) {
		gsub(macro_order[i], macro_defs[macro_order[i]], rest)
	}
	if (! ($2 in macro_defs)) {
		macro_order[length(macro_order) + 1] = $2
	}
	macro_defs[$2] = tolower(rest)
	next
}

{
	$0 = tolower($0)
	for (i = 1; i <= length(macro_order); i++) {
		gsub(macro_order[i], macro_defs[macro_order[i]], $0)
	}
	for (i = 1; i <= NF; i++) {
		if ($i ~ /-?[0-9]+/) {
			stack[length(stack) + 1] = $i
		}
		if ($i in bivariate_ops && length(stack) == 1) {
			bail("only one value on the stack")
		}
		if (($i in bivariate_ops || $i in univariate_ops) && length(stack) == 0) {
			bail("empty stack")
		}
		if ($i !~ /-?[0-9]+/ && ! ($i in bivariate_ops) && ! ($i in univariate_ops)) {
			bail("undefined operation")
		}
		switch ($i) {
		case "+":
			add()
			break
		case "-":
			subtract()
			break
		case "*":
			multiply()
			break
		case "/":
			divide()
			break
		case "swap":
			swap()
			break
		case "over":
			over()
			break
		case "dup":
			dup()
			break
		case "drop":
			drop()
			break
		}
	}
	for (k in stack) {
		_out = (k == 1) ? stack[k] : _out " " stack[k]
	}
	print _out
}


function add()
{
	stack[length(stack) - 1] = stack[length(stack) - 1] + stack[length(stack)]
	delete stack[length(stack)]
}

function bail(message)
{
	print(message) >> "/dev/stderr"
	exit 1
}

function divide()
{
	if (stack[length(stack)] == 0) {
		bail("divide by zero")
	}
	stack[length(stack) - 1] = int(stack[length(stack) - 1] / stack[length(stack)])
	delete stack[length(stack)]
}

function drop()
{
	delete stack[length(stack)]
}

function dup()
{
	stack[length(stack) + 1] = stack[length(stack)]
}

function multiply()
{
	stack[length(stack) - 1] = stack[length(stack) - 1] * stack[length(stack)]
	delete stack[length(stack)]
}

function over()
{
	stack[length(stack) + 1] = stack[length(stack) - 1]
}

function subtract()
{
	stack[length(stack) - 1] = stack[length(stack) - 1] - stack[length(stack)]
	delete stack[length(stack)]
}

function swap(_a, _b)
{
	_a = stack[length(stack) - 1]
	_b = stack[length(stack)]
	stack[length(stack) - 1] = _b
	stack[length(stack)] = _a
}
