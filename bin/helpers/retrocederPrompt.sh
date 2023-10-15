# Retrocede el prompt la cantidad de lineas que se le indique
function retrocederPrompt() {
    for ((i = 0; i < $1; i++)); do
        tput cuu1 && tput ed
    done
}

# Mueve el prompt a la linea indicada
function moverPrompt() {
    # Move el cursor
    echo -e "\033[$(($1 - 2));1H"

    # Borra las lineas desde la linea actual hasta el final
    echo -e "\033[J"
}
