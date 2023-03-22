#!/bin/bash

echo "Creating a new Django project..."
echo ""

# Prompt user for project name
read -p "Enter project name: " project_name

# Create virtual environment
virtualenv env

# Activate virtual environment
source env/bin/activate

# Install Django
pip install django

# Create Django project
django-admin startproject $project_name .

# Create a new app within the project
read -p "Enter app name: " app_name
python manage.py startapp $app_name

echo "Django project created successfully!"
