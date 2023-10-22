#!/bin/bash

. $SCRIPTS/registarPedidos.sh

clear
echo ""
echo "${CYAN}Inicializando aplicación...${N}"

if [ ! -d $REGISTROS ]; then
    mkdir $REGISTROS
fi

if [ -f $PRODUCTOS ]; then
    rm -f $PRODUCTOS $PEDIDOS $CLIENTES
fi

# Inicializamos el archivo de productos
touch $PRODUCTOS $PEDIDOS $CLIENTES

# Ingresamos los títulos de la tabla
echo "ID|Descripción|Precio|Stock" >>$PRODUCTOS
echo "ID|Fecha|Tel. Cliente|ID Combo|Cantidad|Total $|Vendedor" >>$PEDIDOS
echo "ID|Nombre|Telefono" >>$CLIENTES

# Ingresamos los productos (Combos) Random
nombreCombos=(
    "Combo Delicioso"
    "Super Combinación"
    "Menú Gourmet"
    "Comida Festiva"
    "Combo Energético"
    "Combo Saludable"
    "Sabores Variados"
    "Fiesta de Sabores"
    "Combo Especial"
    "Sabor Tradicional"
)
for i in {1..10}; do
    precio=$(($RANDOM % 500 + 200))
    stock=$(($RANDOM % 100 + 80))
    nombreRandom=${nombreCombos[$(($RANDOM % 10))]}
    echo "C$i|$nombreRandom|$precio|$stock" >>$PRODUCTOS
done

# Ingresamos los clientes Random
tempClientes=("Roberto" "Carlos" "Juan" "Pedro" "Maria" "Jose" "Luis" "Ana" "Marta" "Lucia" "Raul" "Jorge" "Ricardo" "Fernando" "Miguel" "Pablo" "Santiago" "Diego" "Daniel" "Manuel")
for i in {0..19}; do
    nombreCliente=${tempClientes[$i]}
    echo "$(($i + 1))|$nombreCliente|11111$i" >>$CLIENTES
done

# Ingresamos los pedidos Random
vendedor=("Fede" "Eze" "Pablo" "Nacho" "Gonza" "Tincho")

# Ingresamos los pedidos Random con fecha en random en incremento

for i in {1..50}; do
    idCliente=$(($RANDOM % 20 + 1))
    idCombo=$(($RANDOM % 10 + 1))
    cantidad=$(($RANDOM % 10 + 1))
    total=$(($(grep "^C$idCombo|" $PRODUCTOS | cut -d"|" -f3) * $cantidad))
    vendedor=${vendedor[$(($RANDOM % 6))]}

    diaRandom=$(($RANDOM % 30 + 1))
    if [ $diaRandom -lt 10 ]; then
        diaRandom="0$diaRandom"
    fi
    mesRandom=$(($RANDOM % 12 + 1))
    if [ $mesRandom -lt 10 ]; then
        mesRandom="0$mesRandom"
    fi
    anioRandom="2023"
    horaRandom=$(($RANDOM % 24))
    if [ $horaRandom -lt 10 ]; then
        horaRandom="0$horaRandom"
    fi
    minRandom=$(($RANDOM % 60))
    if [ $minRandom -lt 10 ]; then
        minRandom="0$minRandom"
    fi
    fechaRandom="$diaRandom-$mesRandom-$anioRandom.$horaRandom:$minRandom:00"
    registroPedido $(grep "^$idCliente|" $CLIENTES | cut -d"|" -f3) "C$idCombo" $cantidad $total $vendedor $fechaRandom
done

spinner 20

echo -e "${GREEN}Todo OK${N} \n"

echo "Ejecute el programa nuevamente"

exit 0
