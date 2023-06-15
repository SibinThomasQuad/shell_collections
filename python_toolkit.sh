#!/bin/bash

# Update package lists
sudo apt update

# Install Python and pip
sudo apt install -y python3 python3-pip

# Install development tools
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev

# Install code editors and IDEs
sudo apt install -y vim nano emacs pycharm

# Install version control tools
sudo apt install -y git

# Install virtual environment tool
sudo apt install -y python3-venv

# Install package management tool
sudo apt install -y python3-pip

# Install formatting and linting tools
pip3 install black flake8 pylint

# Install Python testing frameworks
pip3 install pytest coverage

# Install data science and machine learning libraries
pip3 install numpy pandas matplotlib scikit-learn tensorflow

echo "Python developer tools installation complete."
