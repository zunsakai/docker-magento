#!/usr/bin/env bash

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

# Get list files in magento/
versions=()
for file in $(find magento/ -type f); do
    versions+=(${file#magento/})
done

# Sort the versions
IFS=$'\n' versions=($(sort <<<"${versions[*]}"))
unset IFS

echo "Select the version you want to deploy:"
select_option "${versions[@]}"
choice=$?

# Get the selected version
selected_version=${versions[$choice]}

echo "Deploying: $selected_version"

source "magento/$selected_version"

# if selected_version lower than 2.4.8, php version is 8.1, else 8.2
if [ $(awk 'BEGIN {print ("'$selected_version'" < "2.4.8")}') -eq 1 ]; then
    php_version=8.1
else
    php_version=8.2
fi

# Build the docker image
docker build --build-arg MAGENTO_VERSION=$selected_version --build-arg PHP_VERSION=$php_version -t magento:m2-ce-$selected_version .

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --run) run=true ;;
        --test) test=true ;;
        --push) push=true ;;
    esac
    shift
done

if [ "$run" = true ]; then
    # Run the docker container
    docker run -p $DEFAULT_PORT:$DEFAULT_PORT -it --rm magento:m2-ce-$selected_version bash
elif [ "$test" = true ]; then
    # Run the docker container
    docker run -p $DEFAULT_PORT:$DEFAULT_PORT -it --rm magento:m2-ce-$selected_version bash
    # Remove image
    docker rmi magento:m2-ce-$selected_version
elif [ "$push" = true ]; then
    # Run the docker container
    docker run -p $DEFAULT_PORT:$DEFAULT_PORT -it --rm magento:m2-ce-$selected_version bash
    # Push the image to docker hub
    docker tag magento:m2-ce-$selected_version zunsakai/magento:m2-ce-$selected_version
    docker push zunsakai/magento:m2-ce-$selected_version
    # Remove image
    docker rmi magento:m2-ce-$selected_version
    docker rmi zunsakai/magento:m2-ce-$selected_version
fi
