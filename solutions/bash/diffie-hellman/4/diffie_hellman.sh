#!/usr/bin/env bash
# Use bc external tool or suffer from overflow error
if [ "$1" == "privateKey" ]; then echo $((2 + RANDOM % ($2 - 2))); else bc <<<"scale=0;$3^$4%$2"; fi
