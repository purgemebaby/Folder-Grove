#!/bin/bash

#Constants
script_path=$(dirname "$(realpath "$0")")
custom_configs="$script_path/fg_presets"

[ ! -d "$custom_configs" ] && mkdir "$custom_configs"

#Functions
source "$script_path/options.sh"

#----- Decoration -----
G=$(tput setaf 2)
R=$(tput setaf 1)
Y=$(tput setaf 3)
W=$(tput setaf 7)
B=$(tput setaf 4)
M=$(tput setaf 5)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)



#----- Title project ------
echo "${W}${BOLD}
 ____  _____  __    ____  ____  ____     ___  ____  _____  _  _  ____ 
( ___)(  _  )(  )  (  _ \( ___)(  _ \   / __)(  _ \(  _  )( \/ )( ___)
 )__)  )(_)(  )(__  )(_) ))__)  )   /  ( (_-. )   / )(_)(  \  /  )__) 
(__)  (_____)(____)(____/(____)(_)\_)   \___/(_)\_)(_____)  \/  (____)
"

echo


echo "${G}
               ,@@@@@@@,
       ,,,.   ,@@@@@@/@@,  .oo8888o.
    ,&%%&%&&%,@@@@@/@@@@@@,8888\88/8o
   ,%&\%&&%&&%,@@@\@@@/@@@88\88888/88'
   %&&%&%&/%&&%@@\@@/ /@@@88888\88888'
   %&&%/ %&%%&&@@\ V /@@' ` `/88'
   ` ` /%&'    |.|        \ '|8'
       |o|        | |         | |
       |.|        | |         | |
 \\/ ._\//_/__/  ,\_//__\\/.  \_//__/_ "

#----- Description -----
echo -e "${W}\nNote: This tool may have some bugs or limitations. ${Y}2)${W} and ${Y}3)${W} are limitated to create only one level of subfiles (at this moment). ${Y}1)${W} have project structures only for ${B}Python${W}, ${R}Pentesting Working Directory${W} and ${G}C++${W} following the official standards for projects, you can edit this by changing the script and adding more types."

#----- Main menu -----
while true; do
    echo -e "\n Choose an option:\n\n${Y} 1)${W} Default Project Structures\n${Y} 2)${W} Create Non-Persistent Structured Project\n${Y} 3)${W} Create Persistent Structured Project (custom path not available)\n${Y} 4)${W} Load Custom Structured Project\n${Y} 5)${W} Exit" ; read -rs -n1 option ;

    if [[ $option == 1 || $option == 2 || $option == 4 ]]; then
        echo -ne "\nChoose the name of the project: ${Y}" ; read -r name 
        echo -ne "\n${W}Do you want to use current working directory as project's path? (y/n):" ; read -rs -n1 use_pwd 

        #PWD/Custom path
        if [ "$use_pwd" = "y" ] || [ -z "$use_pwd" ]; then
            path=$(pwd)
        else
            while true; do
                echo -ne "\nEnter the path where you want to create the project: " ; read -r path
                if [ -d "$path" ]; then
                    break
                else
                    echo "The path $path does not exist. Please enter a valid path."
                fi
            done
        fi

        #Check if the project already exists
        if [ -d "$path/$name" ]; then
            echo "The project/folder $name already exists at $path."
            continue
        fi
    fi

    case $option in

    # ----- Default project tree folder -----
    1)
        echo -e "\n\nType of project:\n\n${Y} 1) ${B}Python\n${Y} 2) ${G}C++ \n${Y} 3) ${R}Pentesting WD ${W}"; read -rs -n1 project_type

        case $project_type in
        1)
            #Python project
            python_project "$path" "$name"
            ;;
        2)
            #C++ project
            cpp_project "$path" "$name"
            ;;
        3)
            #Pentesting WD
            pentesting_project "$path" "$name"
            ;;
        esac
        echo -e "\nProject ${Y}$name${W} created successfully at $path."
        echo "-------------------------------------"
        ;;

    # ----- Create non-persistent structured project -----
    2)
        non_persistent "$path" "$name"
        ;;

    # ----- Create persistent structured project -----
    3)
        echo -ne "\nHow do you want to name the project configuration?: ${Y}" ; read -r name_project

        persistent "$name_project"

        echo -e "\n${W}Project configuration $name_project saved successfully"
        echo "-------------------------------------"
        ;;
    # ----- Load custom structured project -----
    4)
        echo -e "\n\nThe project configuration is saved in: \n\n ${Y}1)${W} Default config folder \n ${Y}2)${W} Custom path" ; read -rs -n1 config_option

        # Default config folder/Custom path
        case $config_option in
        1)
            echo -e "\nList of project configurations detected:\n"
            ls "$custom_configs" | awk -F'.' '{print " - \033[1;33m" $1 "\033[0m"}'
            echo -ne "${BOLD}${W}\nEnter the name of the project configuration: ${Y}" ; read -r name_config
            [ ! -f "$custom_configs/$name_config.txt" ] && echo "${W}The project configuration ${Y}$name_config${W} does not exist." && exit 1

            load "$custom_configs" "$name_config" "$path" "$name"
            echo -e "\n${W}Project ${Y}$name${W} created successfully at $path."
            echo "-------------------------------------"
            ;;
        
        2)
            echo -ne "\nEnter the path where the project configuration is saved (without the file.txt): ${Y}" ; read -r path_config
            echo -ne "\n${W}Enter the name of the project configuration (with extension .txt): ${Y}" ; read -r name_config
            [ ! -f "$path_config/$name_config" ] && echo "${W}The project configuration ${Y}$name${W} does not exist at $path." && exit 1

            load "$path_config" "$name_config" "$path" "$name"
            echo -e "\n${W}Project ${Y}$name${W} created successfully at $path."
            echo "-------------------------------------"
            ;;
        esac

        ;;
    # ----- Exit -----
    5)
        echo -e "\nBai bai! :("
        exit 0
        ;;
    esac
done
