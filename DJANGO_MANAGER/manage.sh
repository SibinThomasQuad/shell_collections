#!/bin/bash

# Function to install Django using pip
install_django() {
    pip install django
}

# Function to create a new Django project
create_project() {
    read -p "Enter the name of your Django project: " project_name
    django-admin startproject "$project_name"
}

# Function to create a new Django app within the project
create_app() {
    read -p "Enter the name of the app you want to create: " app_name
    python manage.py startapp "$app_name"

    # Automatically create urls.py for the app
    echo "from django.urls import path

urlpatterns = [
    # Add your app's URL patterns here
]" > "$app_name/urls.py"

    # Map the app's URLs in the project's main URL configuration
    echo "from django.urls import path, include

urlpatterns = [
    path('', include('$app_name.urls')),
]" >> "$project_name/$project_name/urls.py"

    echo "urls.py file has been created for the app and mapped with the project."
}

# Function to set up MySQL connection
setup_mysql() {
    read -p "Enter MySQL database name: " db_name
    read -p "Enter MySQL username: " db_user
    read -s -p "Enter MySQL password: " db_password
    echo ""
    read -p "Enter MySQL host (default: localhost): " db_host
    db_host=${db_host:-"localhost"}

    echo "DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': '$db_name',
            'USER': '$db_user',
            'PASSWORD': '$db_password',
            'HOST': '$db_host',
            'PORT': '',
        }
    }" >> "$project_name/$project_name/settings.py"

    echo "MySQL connection has been set up."
}

# Function to map template folder
map_template_folder() {
    read -p "Enter the path to your template folder: " template_path
    echo "TEMPLATES = [
        {
            'BACKEND': 'django.template.backends.django.DjangoTemplates',
            'DIRS': ['$template_path',],
            'APP_DIRS': True,
            ...
        },
    ]" >> "$project_name/$project_name/settings.py"

    echo "Template folder has been mapped."
}

# Function to collect static files
collect_static() {
    python manage.py collectstatic
}

# Function to perform migrations
perform_migrations() {
    echo "Migration Options:"
    select migrate_option in "Make Migrations" "Migrate All Apps" "Migrate Single App" "Fresh Migrate (Remove all tables)" "Skip Migrations"; do
        case $migrate_option in
            "Make Migrations")
                python manage.py makemigrations
                ;;
            "Migrate All Apps")
                python manage.py migrate
                ;;
            "Migrate Single App")
                read -p "Enter the name of the app to migrate: " app_to_migrate
                python manage.py migrate "$app_to_migrate"
                ;;
            "Fresh Migrate (Remove all tables)")
                python manage.py flush --no-input
                python manage.py makemigrations
                python manage.py migrate
                ;;
            "Skip Migrations")
                echo "Skipping migrations."
                ;;
            *)
                echo "Invalid option. Please select a valid option."
                continue
                ;;
        esac
        break
    done
}

# Main script
echo "Welcome to Django Project and App creator!"

# Prompt to install Django
read -p "Do you want to install Django? (y/n): " install_django_choice

if [ "$install_django_choice" = "y" ]; then
    install_django
fi

# Create a new Django project
echo "Do you want to create a new Django project?"
select project_option in "Yes" "No"; do
    case $project_option in
        Yes)
            create_project
            break
            ;;
        No)
            echo "Skipping project creation."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Create a new app within the project
echo "Do you want to create a new app within the project?"
select app_option in "Yes" "No"; do
    case $app_option in
        Yes)
            create_app
            break
            ;;
        No)
            echo "Skipping app creation."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Set up MySQL connection
echo "Do you want to set up MySQL connection?"
select mysql_option in "Yes" "No"; do
    case $mysql_option in
        Yes)
            setup_mysql
            break
            ;;
        No)
            echo "Skipping MySQL connection setup."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Map template folder
echo "Do you want to map the template folder?"
select template_option in "Yes" "No"; do
    case $template_option in
        Yes)
            map_template_folder
            break
            ;;
        No)
            echo "Skipping template folder mapping."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Collect static files
echo "Do you want to collect static files?"
select static_option in "Yes" "No"; do
    case $static_option in
        Yes)
            collect_static
            break
            ;;
        No)
            echo "Skipping collecting static files."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Perform migrations
echo "Do you want to perform migrations?"
select migrations_option in "Yes" "No"; do
    case $migrations_option in
        Yes)
            perform_migrations
            break
            ;;
        No)
            echo "Skipping migrations."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

echo "Your Django project and app have been created successfully!"
