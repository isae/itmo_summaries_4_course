#!/bin/sh
ghc --make grep.hs
./grep "$@"
