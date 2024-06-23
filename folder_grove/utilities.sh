W=$(tput sgr0)
Y=$(tput setaf 3)
BOLD=$(tput bold)


subfolder1() {
    local path="$1"
    local name="$2"
    local dir="$3"

    echo -ne "\n${W}Do you want to create subfolders in $dir? (y/n):" ; read -rs -n1 confirm

    if [ "$confirm" = "y" ]; then
        echo -ne "\nType the name of the subfolders: ${Y}" ; read -r subfolders
        IFS=',' read -r -a subfolder_array <<<"$subfolders"

        for subfolder in "${subfolder_array[@]}"; do
            local new_dir="$path/$name/$dir/$subfolder"
            mkdir -p "$new_dir"
            if [ -d "$new_dir" ]; then
                subfolder1 "$path/$name/$dir" "" "$subfolder"
            fi
        done
    fi
}


save_config() {
    local name_project="$1"

    # First level
    echo -ne "\nType the name of folders you want to save separated by commas (e.g src,docs,tests...): ${Y}" ; read -r folders
    IFS=',' read -ra folder_array <<<"$folders"
    for element in "${folder_array[@]}"; do
        echo "$name_project/$element" >>"$custom_configs/$name_project.txt"
    done

    # Files
    echo -e "\n${W}Type the name of files you want to save separated by commas (e.g main.py,README.md,requirements.txt...): ${Y}" ; read -r files
    IFS=',' read -ra file_array <<<"$files"
    for element in "${file_array[@]}"; do
        echo "$name_project/$element" >>"$custom_configs/$name_project.txt"
    done

    # Subfolders
    for element in "${folder_array[@]}"; do
        save_config_subfolders "$name_project/$element"
    done
}

save_config_subfolders() {
    local base_path="$1"

    echo -ne "\n${W}Do you want to save subfolders in $base_path? (y/n):" ; read -rs -n1 confirm
    if [ "$confirm" != "y" ]; then
        return
    fi

    echo -ne "\nType the name of the subfolders: ${Y}" ; read -r subfolders
    IFS=',' read -ra subfolder_array <<<"$subfolders"

    for subfolder in "${subfolder_array[@]}"; do
        local subfolder_path="$base_path/$subfolder"
        echo "$subfolder_path" >>"$custom_configs/$name_project.txt"

        # Check for sub-subfolders recursively
        save_config_subfolders "$subfolder_path"
    done
}



