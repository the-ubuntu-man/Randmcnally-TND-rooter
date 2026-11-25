#!/bin/bash
python3 mtk.py rl /home/theubuntuman/tnd750_backup --skip userdata,navidata
source "$(dirname $0)/mtkclient/venv/bin/activate"

python3 "$(dirname $0)/mtkclient/mtk.py" $@
