#!/bin/bash

show_menu() {
    echo "Git Operations Menu:"
    echo "1. Check if Git is Installed"
    echo "2. Install Git"
    echo "3. Clone Repository"
    echo "4. Add Single File"
    echo "5. Add All Files"
    echo "6. Commit"
    echo "7. Pull"
    echo "8. Push"
    echo "9. View Status"
    echo "10. Checkout"
    echo "11. Show Commands"
    echo "12. Move to Git Directory"
    echo "13. Exit"
}

echo -e "\e[1;34mGIT-.SH\e[0m"
echo "Welcome to the Git Operations Script!"

while true; do
    show_menu
    read -p "Enter your choice (1-13): " choice

    case $choice in
        1)
            if command -v git &>/dev/null; then
                echo -e "\e[32mGit is installed.\e[0m"
            else
                echo -e "\e[31mGit is not installed.\e[0m"
            fi
            ;;
        2)
            if command -v git &>/dev/null; then
                echo -e "\e[32mGit is already installed.\e[0m"
            else
                sudo apt-get update
                sudo apt-get install git
                echo -e "\e[32mGit has been installed.\e[0m"
            fi
            ;;
        3)
            read -p "Enter repository URL: " repo_url
            git clone "$repo_url"
            ;;
        4)
            read -p "Enter file path to add: " file_path
            git add "$file_path"
            ;;
        5)
            git add .
            ;;
        6)
            read -p "Enter commit message: " commit_message
            git commit -m "$commit_message"
            ;;
        7)
            git pull
            ;;
        8)
            git push
            ;;
        9)
            git status
            ;;
        10)
            read -p "Enter branch or commit to checkout: " checkout_target
            git checkout "$checkout_target"
            ;;
        11)
            echo "Commands used in this script:"
            cat "$0"
            ;;
        12)
            read -p "Enter the Git directory path: " git_directory
            cd "$git_directory"
            echo "Moved to Git directory: $(pwd)"
            ;;
        13)
            echo "Exiting the script."
            exit
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac

    echo
done
