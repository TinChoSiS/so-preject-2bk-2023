#!/bin/bash

# Función para mostrar la lista de Combos con su precio y stock
function mostrarProductos {
    printTitle "Consulta de Stock"
    column -t -o " | " -s "|" $PRODUCTOS
    pause "Presione cualquier tecla para continuar... " true
}

# Función para mostrar la lista de Clientes
function mostrarClientes {
    printTitle "Consulta de Clientes"
    column -t -o " | " -s "|" $CLIENTES
    pause "Presione cualquier tecla para continuar... " true
}

# Función para mostrar la lista de Pedidos
function mostrarPedidos {
    printTitle "Consulta de Pedidos"
    echo -e "${YELLOW} Últimos 20 pedidos:${N}"
    echo -e "$(head -n 1 $PEDIDOS)" "\n""$(tail -n 20 $PEDIDOS)" | column -t -o " | " -s "|"
    echo ""

    # Menú de opciones para filtrar la información de pedidos
    while true; do
        read -s -n 1 -p "${CYAN}Opciones de filtrado${N}:
|=====================|
    $(menuOption 1 "Total Ventas x Combo")
    $(menuOption 2 "Total $ x Cliente")
    $(menuOption 3 "Compras x Cliente")
    $(menuOption 4 "Ventas x Vendedor x Mes")

  $(menuOption s "Volver")
|=====================|
" op

        case $op in
        s | S) clear && break ;;
        1) clear && filterProductos 1 ;;
        2) clear && filterProductos 2 ;;
        3) clear && filterProductos 3 ;;
        4) clear && filterProductos 4 ;;
        *) clear && echo -e "${MAGENTA}Opción no válida. Intenta de nuevo${N}\n" ;;
        esac
    done
}

# Función principal para evaluar cada caso de la opción seleccionada
function filterProductos() {
    case $1 in
    1) # Total Ventas x Combo
        printTitle "Total Ventas x Combo"
        while true; do
            # Solicitamos el ID del Combo y el Mes [Opcional]
            read -p "${YELLOW}Ingrese el Código del Combo:${N}" idCombo
            read -p "${YELLOW}Ingrese el Mes:${BLACK} (1-12 | Vacio=Todos)${N} " mes

            # Validamos que el ID del Combo no esté vacío
            if [ ! "$idCombo" ]; then
                echo -e "${MAGENTA}ERROR: Debe ingresar un Código${N}"
                moverPrompt 2
                continue
            else
                # validamos que el ID del Combo exista en el archivo de productos
                idCombo=$(echo $idCombo | tr '[:lower:]' '[:upper:]')
                combo=$(grep "^$idCombo|" $PRODUCTOS)
                if [ ! "$combo" ]; then
                    moverPrompt 2
                    echo -e "${MAGENTA}ERROR: No se encontró el Combo con este Código${N}"
                    continue
                fi
            fi

            # Realizamos Validaciones del mes, y actuamos en consecuencia.
            if [ "$mes" ]; then
                if [ "$mes" -lt 1 ] || [ "$mes" -gt 12 ]; then
                    moverPrompt 2
                    echo -e "${MAGENTA}ERROR: El Mes debe ser un número entre 1 y 12${N}"
                    continue
                fi

                if [ "$mes" -lt 10 ]; then
                    mes="0$mes"
                fi
                ventasLineas=$(grep "|$idCombo|" $PEDIDOS | grep "\-$mes\-")
            else
                ventasLineas=$(grep "|$idCombo|" $PEDIDOS)
            fi

            # Validamos que se hayan encontrado ventas para el Combo
            if [ ! "$ventasLineas" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontraron ventas para el Combo${N}"
                continue
            fi

            moverPrompt 2
            break
        done
        # Si la información es correcta, continuamos con el proceso

        # Obtenemos el nombre del Combo y la cantidad de ventas
        nombreCombo=$(echo $combo | cut -d"|" -f2)
        cantidadVentas=$(echo "$ventasLineas" | wc -l)

        # Sumamos el total de ventas y cantidades
        totalCantidad=0
        total=0
        IFS=$'\n'
        for linea in $ventasLineas; do
            totalLinea=$(echo $linea | cut -d"|" -f6)
            totalCantidadLinea=$(echo $linea | cut -d"|" -f5)
            totalCantidad=$(($totalCantidad + $totalCantidadLinea))
            total=$(($total + $totalLinea))
        done

        if [ "$mes" ]; then
            echo -e "${BLUE}Se realizaron ${YELLOW}$cantidadVentas${BLUE} ventas con ${YELLOW}$totalCantidad ${BLUE}Combo/s ${YELLOW}$nombreCombo ($idCombo)${BLUE} en el Mes ${YELLOW}$mes${BLUE} por un total de: ${GREEN}\$$total${N}"
        else
            echo -e "${BLUE}Se realizaron ${YELLOW}$cantidadVentas${BLUE} ventas con ${YELLOW}$totalCantidad ${BLUE}Combo/s ${YELLOW}$nombreCombo ($idCombo)${BLUE} por un total de: ${GREEN}\$$total${N}"
        fi
        echo -e "\n"
        ;;

    2) # Total $ x Cliente
        printTitle "Total $ x Cliente"
        while true; do
            read -p "${YELLOW}Ingrese el Teléfono del Cliente:${N}" telefonoCliente

            if [ ! "$telefonoCliente" ]; then
                echo -e "${MAGENTA}ERROR: Debe ingresar un Teléfono${N}"
                moverPrompt 2
                continue
            fi

            cliente=$(grep "|$telefonoCliente$" $CLIENTES)
            if [ ! "$cliente" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontró el Cliente con este Teléfono${N}"
                continue
            fi

            nombreCliente=$(echo $cliente | cut -d"|" -f2)
            ventasLineas=$(grep "|$telefonoCliente|" $PEDIDOS)
            cantidadVentas=$(echo "$ventasLineas" | wc -l)
            if [ ! "$ventasLineas" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontraron ventas para el Cliente${N}"
                continue
            fi
            moverPrompt 2
            break
        done

        total=0
        IFS=$'\n'
        for linea in $ventasLineas; do
            totalLinea=$(echo $linea | cut -d"|" -f6)
            total=$(($total + $totalLinea))
        done
        echo -e "${BLUE}El Cliente ${YELLOW}$nombreCliente ($telefonoCliente)${BLUE} realizó ${YELLOW}$cantidadVentas${BLUE} compra/s por un total de: ${GREEN}\$$total${N}"
        echo -e "\n"
        ;;

    3) # Compras x Cliente
        printTitle "Compras x Cliente"
        while true; do
            read -p "${YELLOW}Ingrese el Teléfono del Cliente:${N}" telefonoCliente

            if [ ! "$telefonoCliente" ]; then
                echo -e "${MAGENTA}ERROR: Debe ingresar un Teléfono${N}"
                moverPrompt 2
                continue
            fi

            cliente=$(grep "|$telefonoCliente$" $CLIENTES)
            if [ ! "$cliente" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontró el Cliente con este Teléfono${N}"
                continue
            fi

            nombreCliente=$(echo $cliente | cut -d"|" -f2)
            pedidosLineas=$(grep "|$telefonoCliente|" $PEDIDOS)
            if [ ! "$pedidosLineas" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontraron pedidos para el Cliente${N}"
                continue
            fi
            moverPrompt 2
            echo -e "${BLUE}El Cliente ${YELLOW}$nombreCliente ($telefonoCliente)${BLUE} realizó los siguientes pedidos:${N}"
            echo ""
            echo -e "$(head -n 1 $PEDIDOS)" "\n""$pedidosLineas" | column -t -o " | " -s "|"
            echo ""
            break
        done
        ;;
    4) # Ventas x Vendedor x Mes
        printTitle "Ventas x Vendedor x Mes"
        while true; do
            read -p "${YELLOW}Ingrese el Mes:${N}" mes

            if [ ! "$mes" ]; then
                echo -e "${MAGENTA}ERROR: Debe ingresar un Mes${N}"
                moverPrompt 2
                continue
            fi

            if [ "$mes" -lt 1 ] || [ "$mes" -gt 12 ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: El Mes debe ser un número entre 1 y 12${N}"
                continue
            fi

            if [ "$mes" -lt 10 ]; then
                mes="0$mes"
            fi

            read -p "${YELLOW}Ingrese el Año:${BLACK} (2023)${N}" anio

            if [ ! "$anio" ]; then
                anio=2023
            fi
            mesABuscar="$mes-$anio"
            pedidosLineas=$(grep "\-$mesABuscar" $PEDIDOS)

            if [ ! "$pedidosLineas" ]; then
                moverPrompt 2
                echo -e "${MAGENTA}ERROR: No se encontraron pedidos para el Mes y Año ingresados${N}"
                continue
            fi
            moverPrompt 2
            echo -e "${BLUE}Se realizaron los siguientes pedidos en el Mes ${YELLOW}$mes/$anio${BLUE}:${N}"
            echo ""
            echo -e "$(head -n 1 $PEDIDOS)" "\n""$pedidosLineas" | column -t -o " | " -s "|"
            echo ""
            break
        done
        ;;
    *) clear && echo -e "${MAGENTA}Opción no válida. Intenta de nuevo${N}\n" ;;
    esac

}
