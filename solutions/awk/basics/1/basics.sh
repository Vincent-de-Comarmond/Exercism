#!/bin/sh

# You will implement this exercise with a shell script that contains some awk commands.
# In subsequent exercises, the solution file will contains only awk code.
#
# You have 4 tasks to solve.
# Replace the `{exit}` action with awk code to solve the task.

## task 1
awk 'BEGIN{FS=":"}{print $1}' ./passwd

## task 2
awk '{print NR}' ./passwd

## task 3
awk -F ":" '$6 !~/^\/root|^\/home/ {print $0}' ./passwd

## task 4
awk -F ":" '$6 ~/^\/root|^\/home/ && $7 == "/bin/bash" {print $0}' ./passwd
