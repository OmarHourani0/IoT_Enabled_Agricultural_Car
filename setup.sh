#!/bin/bash

# Create and activate the virtual environment
python3 -m venv thingspeak
source thingspeak/bin/activate

# Install dependencies
pip install -r requirements.txt

source thingspeak/bin/activate

echo "Environment setup complete.
