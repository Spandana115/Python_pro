#!/bin/bash

# Update the package lists
sudo yum update -y

# Install Python3, pip, and Git
sudo yum install -y python3 python3-pip git

# Clone the GitHub repository
git clone https://github.com/Spandana115/Medical-Insurance.git

# Move into the application directory
cd Medical-Insurance

# Install the required Python packages
pip3 install -r requirements.txt

# Start the Python application
nohup python3 app.py &

