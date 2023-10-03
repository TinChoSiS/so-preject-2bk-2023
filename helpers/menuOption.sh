function menuOption {

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: menuOption necesita dos parámetros"
        exit 1
    fi

    if [ "$1" = "s" ] || [ "$1" = "S" ]; then
        echo -e "${B}${YELLOW}s|S)${N} ${2}"
    else
        echo -e "${B}${CYAN}${1})${N} ${2}"
    fi

}
