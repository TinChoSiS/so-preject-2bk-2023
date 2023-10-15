#!/bin/bash

printTitle "Registros de Pedidos"

# Función para mostrar la ayuda de la aplicación

echo -e "Bienvendido/aZ a la ayuda de la aplicación de pedidos."
echo -e "Esta aplicación permite registrar pedidos de combos de comida."
echo -e "Se puede realizar mediante la ejecución de la aplicación en modo interactivo o mediante la ejecución de comandos."
echo ""
echo -e "Para ejecutar la aplicación en modo interactivo, ejecute el comando ${CYAN}./app.sh${N}"
echo -e "Para ejecutar la aplicación en modo comandos, ejecute el comando ${CYAN}./app.sh -c${N}"

echo -e "
    -h, --help      # Muestra la ayuda de la aplicación
    -i, --init      # Inicializa la aplicación con datos de prueba
    -c, --command   # Ejecuta la aplicación en modo comandos

    En el caso de utilizar la aplicación en modo comandos, se pueden utilizar los siguientes comandos:
    Ejemplo1: app.sh -c <comando> <parametros>
    Ejemplo2: app.sh --command <comando> <parametros>

    Comandos:
        add <telefono> <codigo_producto> <cantidad> # Agrega un nuevo pedido
"

exit 0
