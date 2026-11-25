#!/bin/bash
cd "$(dirname $0)/mtkclient"
python3 -m venv venv

. ./venv/bin/activate
pip install -r requirements.txt