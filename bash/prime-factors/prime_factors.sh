#!/usr/bin/env bash
factor "$1" | cut -d":" -f2- | cut -c2-
