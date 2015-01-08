#!/bin/bash
clingo-4-banane --ifs="\n" "$@" convert.lp | grep "^_" | sed -e 's/$/./' -e 's/^_//'
