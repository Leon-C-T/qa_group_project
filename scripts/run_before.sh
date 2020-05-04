#!/bin/bash

export url="$(curl https://ipinfo.io/ip)"
python3 -m coverage run --source=. -m pytest scripts/test/testing.py
python3 -m coverage report -m