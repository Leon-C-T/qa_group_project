#!/bin/bash
source /var/lib/jenkins/.bashrc

python3 -m coverage run --source=. -m pytest scripts/test/testing.py
python3 -m coverage report -m