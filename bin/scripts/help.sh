#!/bin/bash

printTitle "Registros de Pedidos"

# Función para mostrar la ayuda de la aplicación

echo -e "Bienvendid@ a la ayuda de la aplicación de pedidos."
echo -e "Esta aplicación permite registrar pedidos de combos de comida."
echo -e "Se puede realizar mediante la ejecución de la aplicación en modo interactivo o mediante la ejecución de comandos."
echo ""
echo -e "Para ejecutar la aplicación en modo interactivo, ejecute el comando ${CYAN}./app.sh${N}"
echo -e "Para ejecutar la aplicación en modo comandos, ejecute el comando ${CYAN}./app.sh -c${N}"

echo -e "
    -h, --help      # Muestra la ayuda de la aplicación
    -i, --init      # Inicializa la aplicación con datos de prueba
    -c, --command   # Ejecuta la aplicación en modo comandos
        -a, --add <telefono> <codigo_producto> <cantidad> # Agrega un nuevo pedido
        -d, --delete <id_pedido> # Elimina un pedido
"

exit 0
