# ingresar.sh
#!/bin/bash

. $SCRIPTS/registarPedidos.sh

telefono_validos_regex="^09[0-9]{7}$"
nombres_validos_regex="^[A-Za-záéíóúÁÉÍÓÚüÜñÑ]+$"

while true; do
    printTitle "Ingresar Nuevo Pedido"
    echo -e "Ingrese los datos solicitados."

    # Vendedor definido con el usuario del sistema
    echo -e "\n${GREEN}->${N} Vendedor: $USER"

    # Solicitamos el telefono del cliente
    while true; do
        echo ""
        # Solicitamos el telefono del cliente y lo almacenamos temporalmente para validar.
        read -p "${GREEN}->${N} Telefono del Cliente: " tempCliente

        # Validamos que el telefono del cliente no esté vacío
        if [ ! "$tempCliente" ]; then
            echo -e "${MAGENTA}ERROR: El telefono del cliente no puede estar vacío${N}"
            continue
        fi

        # Validamos que el telefono del cliente no contenga caracteres inválidos
        # limpiarEspaciosExtra es una función definida en helpers/limpiarEspaciosExtra.sh
        tempCliente=$(limpiarEspaciosExtra "$tempCliente")
        if [[ ! $tempCliente =~ $telefono_validos_regex ]]; then
            echo -e "${MAGENTA}ERROR: El telefono del cliente es inválido${N}. Ej: 099123456"
            continue
        fi

        # Buscamos el cliente en el archivo de clientes
        tempClienteExist=$(grep -w $tempCliente$ $CLIENTES)

        # Validamos que el cliente exista
        if [ ! "$tempClienteExist" ]; then
            # No existe el cliente en la base de datos temporal
            echo -e "${MAGENTA}ERROR: El cliente no existe${N}"

            # Opción de crear un nuevo cliente
            read -s -n 1 -p "${YELLOW}--> Desea crear un nuevo cliente? (s/n): ${N}" confirm
            if [ ! $confirm ]; then
                retrocederPrompt 3
                continue
            elif [ $confirm != "s" ]; then
                retrocederPrompt 3
                continue
            fi

            retrocederPrompt 2
            echo -e "\n"

            # Solicitamos el nombre del cliente y lo almacenamos en el archivo temporal.
            # Y validamos el mismo para evitar errores.
            while true; do
                read -p "${YELLOW}-->${N} Nombre del Cliente: " nombreCliente
                if [ ! "$nombreCliente" ]; then
                    echo -e "${MAGENTA}ERROR: El nombre del cliente no puede estar vacío${N}"
                    continue
                fi
                if [[ ! $nombreCliente =~ $nombres_validos_regex ]]; then
                    echo -e "${MAGENTA}ERROR: El nombre del cliente es inválido${N}"
                    continue
                fi
                break
            done
            # Obtenemos el ultimo ID del archivo de clientes y le sumamos 1
            ultimoId=$(($(tail -n 1 $CLIENTES | cut -d"|" -f1) + 1))

            # Almacenamos el nuevo cliente en la variable temporal
            tempClienteExist="$ultimoId|$nombreCliente|$tempCliente"

            # Guardamos el nuevo cliente en el archivo temporal
            echo $tempClienteExist >>$CLIENTES
            retrocederPrompt 4

        fi

        # Acomodamos el Prompt para estilizar la pantalla
        retrocederPrompt 1
        nombreCliente=$(echo $tempClienteExist | cut -d"|" -f2)
        echo -e "${GREEN}->${N} Telefono del Cliente: [$nombreCliente] $tempCliente"

        # Todo correcto, almacenamos el telefono del cliente para reutilizar.
        cliente=$tempCliente
        break
    done

    # Variable auxiliar para eliminar el listado de pantalla al seleccionar.
    listaMostrada=0
    # Solicitamos el producto
    while true; do
        echo ""
        # Solicitamos el código del producto
        read -p "${GREEN}->${N} Código del producto ${BLACK}(deje vacío para ver lista)${N}: " codigo

        # Si el código está vacío, mostramos la lista de productos y volvemos a solicitar el código.
        if [ ! "$codigo" ]; then
            if [ $listaMostrada -eq 0 ]; then
                retrocederPrompt 1
                listaMostrada=1
            elif [ $listaMostrada -eq 1 ]; then
                retrocederPrompt $(($(wc -l <$PRODUCTOS) + 3))
            fi
            echo -e "${YELLOW}--> ${U}Lista de productos:${N}"
            column -t -o " | " -s "|" $PRODUCTOS
            continue
        fi

        # lo modificamos a mayúsculas para descartar errores de usuario
        codigo=$(echo $codigo | tr '[:lower:]' '[:upper:]')

        # Buscamos el producto en el archivo de productos
        tempProducto=$(grep "^$codigo|" "$PRODUCTOS")

        # Validamos que el producto exista
        if [ ! "$tempProducto" ]; then
            echo -e "${MAGENTA}ERROR: El Código del producto no existe${N}"
            continue
        fi

        # Almacenamos el stock del producto
        stock=$(echo $tempProducto | cut -d"|" -f4)

        # Validamos que el producto tenga stock
        if [ $stock -eq 0 ]; then
            echo -e "${YELLOW}--> El producto no tiene stock${N}"
            continue
        fi

        # Si se mostró la lista borramos la lista y retrocedemos el prompt
        if [ $listaMostrada -eq 1 ]; then
            retrocederPrompt $(($(wc -l <$PRODUCTOS) + 3))
            echo "${GREEN}->${N} Código del producto ${BLACK}(deje vacío para ver lista)${N}: $codigo"
            listaMostrada=0
        fi

        # Solicitamos confirmación del producto, se lo contrario se vuelve a solicitar.
        echo -e "${BLUE}--> Nombre:${YELLOW} ${B}$(echo $tempProducto | cut -d"|" -f2)${N}"
        echo -e "${BLUE}--> Precio:${YELLOW} \$ ${B}$(echo $tempProducto | cut -d"|" -f3)${N}"
        echo -e "${BLUE}--> Stock:${YELLOW}  ${B}$(echo $tempProducto | cut -d"|" -f4)${N}"

        tempConfirmFlag=true
        while $tempConfirmFlag; do
            read -n 1 -s -p "${YELLOW}---> Confirmación ${BLACK}(s/n): ${N}" confirm
            echo -e "\n"
            if [ "$confirm" = "n" ]; then
                retrocederPrompt 7
                tempConfirmFlag=false
                break
            elif [ "$confirm" = "s" ]; then
                break
            fi
            retrocederPrompt 2

        done

        if [ $tempConfirmFlag = false ]; then
            continue
        fi

        # Todo correcto, almacenamos el codigo y linea del producto para reutilizar.
        productoLinea=$tempProducto
        productoId=$codigo
        break
    done

    # Solicitamos la cantidad
    while true; do
        # Solicitamos la cantidad del pedido y lo almacenamos temporalmente para validar.
        read -p "${GREEN}->${N} Ingrese la cantidad: " tempCantidad

        # Validamos que la cantidad no esté vacía
        if [ ! "$tempCantidad" ]; then
            echo -e "${MAGENTA}ERROR: La cantidad no puede estar vacía${N}"
            continue
        fi

        # Validamos que la cantidad ingresada no sea menor o igual que 0.
        if [ $tempCantidad -lt 1 ]; then
            echo -e "${MAGENTA}ERROR: La cantidad debe ser mayor a 0${N}"
            continue
        fi

        # Validamos que la cantidad no sea mayor al stock
        if [ $tempCantidad -gt $(echo $productoLinea | cut -d'|' -f4) ]; then
            echo -e "${MAGENTA}ERROR: La cantidad debe ser menor o igual al stock${N}"
            continue
        fi

        # Todo correcto, almacenamos la cantidad para reutilizar.
        cantidad=$tempCantidad
        break
    done

    # Confirmación del pedido
    totalPedido=$(($(echo $productoLinea | cut -d'|' -f3) * $cantidad))
    echo -e "\n${GREEN}${U}Pedido:${N}"
    echo -e "${BLACK}Cliente:  ${CYAN}${B}$cliente [$nombreCliente]${N}"
    echo -e "${BLACK}Producto: ${CYAN}${B}$(echo $productoLinea | cut -d'|' -f2)${N}"
    echo -e "${BLACK}Cantidad: ${CYAN}${B}$cantidad${N}"
    echo -e "${BLACK}Total:   \$ ${CYAN}${B}$totalPedido${N} ${BLACK}(Unidad: \$$(echo $productoLinea | cut -d"|" -f3))${N}"
    echo -e "${BLACK}Vendedor: ${CYAN}${B}$USER${N}"
    while true; do
        echo ""
        read -s -n 1 -p "${YELLOW}-> Revise el Pedido. ¿Es correcto? (s/n): ${N}" confirm
        if [ "$confirm" = "s" ]; then
            # Pedido confirmado, se resta la cantidad ingresada al stock del producto.
            resto=$(($(echo $productoLinea | cut -d "|" -f4) - $cantidad))
            # Obtenemos el número de línea del producto en el archivo de productos.
            numLinea=$(grep -n "^$productoId|" "$PRODUCTOS" | cut -d: -f1)

            # Efecto de carga
            echo -e "\n${YELLOW}--> Registrando pedido...${N}"
            spinner 20

            # Registramos el pedido en el archivo de pedidos.
            registroPedido $cliente $productoId $cantidad $totalPedido

            # Pedido registrado
            echo -e "${GREEN}--> Pedido registrado${N}"
            sleep 2

            # Limpiamos pantalla y salimos del script.
            clear
            break
        elif [ "$confirm" = "n" ]; then
            echo ""
            # Pedido no confirmado.
            clear
            echo -e "${YELLOW}--> Pedido Cancelado${N}"
            sleep 2
            break
        fi
        retrocederPrompt 1

    done
    # Fin del script
    break
done
