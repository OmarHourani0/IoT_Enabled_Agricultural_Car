#!/bin/bash

# Create and activate the virtual environment
python3 -m venv thingspeak
source thingspeak/bin/activate

# Install dependencies
pip install -r requirements.txt

echo "Environment setup complete. Run 'source thingspeak/bin/activate' to activate the environment."
