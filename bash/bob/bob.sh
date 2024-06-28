#!/usr/bin/env bash

if [[ "$1" =~ ^[0-9A-Z[:space:][:punct:]]+\?[[:space:]]*$ && "$1" =~ [A-Z] ]]; then
	echo "Calm down, I know what I'm doing!"
elif [[ "$1" =~ ^[0-9A-Z[:space:][:punct:]]+$ && "$1" =~ [A-Z] ]]; then
	echo "Whoa, chill out!"
elif
	[[ "$1" =~ .*\?[[:space:]]*$ ]]
then
	echo "Sure."
elif [[ "$1" =~ ^[[:space:]]*$ ]]; then
	echo "Fine. Be that way!"
else
	echo "Whatever."
fi
