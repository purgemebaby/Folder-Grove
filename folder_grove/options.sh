script_path=$(dirname "$(realpath "$0")")
custom_configs="$script_path/fg_presets"
source "$script_path/utilities.sh"

W=$(tput setaf 7)
Y=$(tput setaf 3)
BOLD=$(tput bold)


#4)
load() {
    local path_config="$1"
    local name_config="$2"
    local path="$3"
    local name="$4"

    while IFS= read -r path_line; do

        # Get the last part of the path
        file_name=$(basename "$path_line")

        # Check if it has an extension
        if [[ $file_name == *.* ]]; then
            touch "$path/$name/$path_line"
        else
            mkdir -p "$path/$name/$path_line"
        fi
    done <"$path_config/$name_config.txt"
}

#3)
persistent() {
    local name_project="$1"

    echo -ne "\n${W}If it exists another with the same name this will be overwritten, continue? (y/n):" ; read -rs-n1 save
    if [ "$save" = "y" ]; then
        > "$custom_configs/$name_project.txt"
        save_config "$name_project"
        sed -i "s/$name_project\///g" "$custom_configs/$name_project.txt"
    fi
}

#2)
non_persistent() {
    local path="$1"
    local name="$2"

    echo -ne "\nType the name of folders you want to create separated by commas (e.g src,docs,tests...): ${Y}" ; read -r folders ;

    IFS=',' read -ra folder_array <<<"$folders"
    for element in "${folder_array[@]}"; do
        mkdir -p "$path/$name/$element"
    done

    echo -ne "\n${W}Type the name of files with their extension you want to create separated by commas (e.g main.py,README.md,...): ${Y}" ; read -r files

    IFS=',' read -ra file_array <<<"$files"
    for element in "${file_array[@]}"; do
        touch "$path/$name/$element"
    done

    for element in "${folder_array[@]}"; do
        if [ -d "$path/$name/$element" ]; then
            subfolder1 "$path/$name" "" "$element"
        fi
    done

    echo -e "${BOLD}\n\nDo you want to: \n\n${Y} 1)${W} Confirm the creation of this project. \n${Y}${BOLD} 2)${W} Start again." ; read -rs -n1 confirm
    if [ "$confirm" = "1" ]; then
        echo -e "\nProject ${Y}$name${W} created successfully at $path."
        echo "-------------------------------------"
    else
        rm -rf "$path/$name"
        echo -e "\nProject deleted."
        echo "-------------------------------------"
        non_persistent
    fi
}

#1) Defaults
python_project() {
    local path=$1
    local name=$2
    mkdir -p "$path/$name"/{docs,sample,src,tests}
    touch "$path/$name/src"/{main.py,README.md,requirements.txt,setup.py,LICENSE.txt}
    touch "$path/$name/sample"/{core.py,__init__.py}
}

cpp_project() {
    local path=$1
    local name=$2
    mkdir -p "$path/$name"/{build,include,src,external,tools,docs,libs}
    touch "$path/$name/src"/{main.cpp,README.md,LICENSE.txt}
    mkdir -p "$path/$name/src"/{app,common,drivers,test}
}

pentesting_project() {
    local path=$1
    local name=$2
    mkdir -p "$path/$name"/{docs,exploits,reports,scripts,tools}
}
