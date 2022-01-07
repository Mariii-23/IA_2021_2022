#!/usr/bin/env bash
echo -e '\033[1mGaranta que as bibliotecas python termcolor e pyswip estão instaladas!\033[0m\n'
cd interface
read -rp "Do you wish to install termcolor and pyswip modules? " yn
if [ "$yn" = "y" ]; then
    pip install -r requirements.txt
fi
python3 main.py
