#!/usr/bin/env bash

if [ ! -d "pythonvenv" ]; then
    echo "python virtual environment doesn't exist. creating..."
    virtualenv pythonvenv
fi

echo "activating python virtual environment"
source pythonvenv/bin/activate

/usr/bin/env bash
