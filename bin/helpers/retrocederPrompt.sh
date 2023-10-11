# Retrocede el prompt la cantidad de lineas que se le indique
function retrocederPrompt() {
    for ((i = 0; i < $1; i++)); do
        tput cuu1 && tput ed
    done
}
