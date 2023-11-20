# env.sh
#!/bin/bash

# preparamos las variables de trabajo

# Comentar para usar whoami o definido en el sistema
# USER="Tincho"
USER=$(whoami)

# Directorios de trabajo
WORKPATH=$1
LOGS=$WORKPATH/logs
SCRIPTS=$WORKPATH/bin/scripts
HELPERS=$WORKPATH/bin/helpers
REGISTROS=$WORKPATH/registros
PRODUCTOS=$REGISTROS/productos
CLIENTES=$REGISTROS/clientes
PEDIDOS=$REGISTROS/pedidos

# configuramos unos estilos y colores para destacar los mensajes
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)

N=$(tput sgr0) # Normal - restablece todos los estilos
B=$(tput bold) # Bold - negrita
U=$(tput smul) # Underline - subrayado

export BLACK RED GREEN YELLOW BLUE MAGENTA CYAN N B U LOGS SCRIPTS HELPERS REGISTROS PRODUCTOS CLIENTES PEDIDOS USER
# Importamos las funciones necesarias
for file in "${HELPERS}"/*.sh; do
    . "${file}"
done
if [ -f "${SCRIPTS}/registroLogs.sh" ]; then
    . "${SCRIPTS}/registroLogs.sh"
fi

# limpiamos pantalla
tput setaf 0
tput sgr0
tput clear
