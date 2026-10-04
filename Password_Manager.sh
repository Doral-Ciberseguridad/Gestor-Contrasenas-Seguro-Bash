#!/bin/bash



# Nombre de la herramienta
#     ____            _                            _                       /\/|           
#   / ___| ___  ___| |_ ___  _ __    __| | ___    ___ ___  _ __ | |_ _ __ __ _ ___  ___ |/\/   __ _ ___ 
#  | |  _ / _ \/ __| __/ _ \| '__|  / _` |/ _ \  / __/ _ \| '_ \| __| '__/ _` / __|/ _ \ '_ \ / _` / __|
#  | |_| |  __/\__ \ || (_) | |    | (_| |  __/ | (_| (_) | | | | |_| | | (_| \__ \  __/ | | | (_| \__ \
#   \____|\___||___/\__\___/|_|     \__,_|\___|  \___\___/|_| |_|\__|_|  \__,_|___/\___|_| |_|\__,_|___/
#                                                                                                      

# Autor
#   ____             _     ____                                    
#  |  _ \  __ _ _ __| | __ / ___|  ___  __ _ ___  ___  _ __  
#  | | | |/ _` | '__| |/ / \___ \ / _ \/ _` / __|/ _ \| '_ \ 
#  | |_| | (_| | |  |   <   ___) |  __/ (_| \__ \ (_) | | | |
#  |____/ \__,_|_|  |_|\_\ |____/ \___|\__,_|___/\___/|_| |_|
#



# Imprimo el titulo de mi programa.
echo ""
echo "########## GESTOR DE CONTRASEÑAS (BASH LINUX) ##########"

# Actualizo los paquetes del sistema e instalo una herramienta para generar contraseñas.
echo ""
echo "Instalando dependencias necesarias..."
sleep 1.5
sudo apt -qq update 2>/dev/null
sudo apt -qq install pwgen 2>/dev/null

# Muestro al usuario las opciones disponibles que tiene este programa.
echo ""
echo "Opciones:"
echo "1.Generar contraseña"
echo "2.Reforzar contraseña"
echo "3.Ver contraseñas guardadas en el almacén de contraseñas"
echo "4.Guardar contraseña en el almacén de contraseñas"
echo "5.Encriptar y securizar el almacén de contraseñas"
echo "6.Desencriptar el almacén de contraseñas"

# Le pido al usuario que elija una de las opciones y guardo su elección en una variable.
echo ""
read -p "Elige una opción (1-6) --> " opcion_usuario
echo ""




# Uso la utilidad case para ejecutar la opción que ha elegido el usuario.
case $opcion_usuario in 

    # Opción 1: Generar contraseña segura
    1)
        # Creo un bucle que no para hasta que el usuario introduzca un valor valido para elegir la longitud de la contraseña que se va a generar.
        while true; do
            read -p "Indica la longitud de tu contraseña (ej: 9) (Máximo 100 dígitos) --> " longitud_contrasena
            if [[ "$longitud_contrasena" =~ ^[0-9]+$ ]] && (( longitud_contrasena >= 1 && longitud_contrasena <= 100 )); then
            break
            else
                echo "Opción invalida. Vuelve a intentarlo."
            fi
        done


        # Genero la contraseña usando la herramienta que instalé al principio del script.
        echo "Generando clave segura..."
        sleep 1.5
        contrasena=$(pwgen -s $longitud_contrasena 1)
        echo $contrasena


        # Le pregunto al usuario si quiere guardar la contraseña generada en un archivo almacén en el directorio raiz.
        read -p "¿Quieres guardar esta credencial en el almacén de contraseñas? (s/n) --> " guardar_contrasena
        # Creo el archivo almacen en caso de que no exista.
        if [ "$guardar_contrasena" == "s" ]; then
            if [ ! -f "/almacen_contrasenas.txt" ]; then
                touch "/almacen_contrasenas.txt"
            fi

            # Le pido al usuario que me diga un nombre para poder identificar la contraseña más facilmente en ocasiones futuras.
            read -p "Asignale una etiqueta (Ej: Amazon_Password) --> " etiqueta_contrasena

            # Actualizo la contraseña añadiendo la etiqueta que me da el usuario.
            contrasena_final="$etiqueta_contrasena : $contrasena"

            # Añado la contraseña al almacén.
            echo "$contrasena_final" >> /almacen_contrasenas.txt
            echo "Ok. Contraseña guardada."

            # Le pregunto al usuario si quiere ver las credenciales del almacén.
            read -p "¿Quieres ver tus contraseñas guardadas? (/almacen_contrasenas.txt) (s/n) --> " ver_contenedor
            if [ "$ver_contenedor" == "s" ]; then
                cat "/almacen_contrasenas.txt"
            elif [ "$ver_contenedor" == "n" ]; then
                echo "Ok. No se mostrarán las contraseñas"
            else 
                echo "Opción invalida. Vuelve a intentarlo."
            fi

        # Si el usuario no quiere guardar la contraseña termino esta primera opción del programa usando un exit.  
        elif [ "$guardar_contrasena" == "n" ]; then
            echo "Ok. No se va a guardar esta contraseña"
            exit
        else
            echo "Opción invalida. Vuelve a intentarlo."

        fi
        ;;



    # Opcion 2: Reforzar contraseña
    2)
        # Le pido al usuario que introduzca la contraseña que quiere mejorar.
        read -p "Introduce la contraseña que quieres reforzar --> " contrasena_reforzar

        # Le pido al usuario que introduzca la cantidad de caracteres especiales que quiere añadir a la contraseña.
        read -p "Cuantos caracteres especiales quieres añadir a tu password? (Ej:3) --> " agregar_caracteres_especiales
        
        # Guardo en una lista de arrays todos los caracteres especiales que voy a emplear y aleatorizar cuando vaya a generar la contraseña.
        lista_caracteres=("!" "@" "#" "$" "%" "&" "/" "(" ")" "=")
        nuevos_caracteres=""

        # En base a la respuesta que me dio el usuario en la variable agregar_caracteres_especiales, aleatorizo un caracter especial, si el usuario me dijo 3 pues serán 3 caracteres especiales random.
        for ((i=0; i<agregar_caracteres_especiales; i++)); do
            index=$((RANDOM % 10))
            nuevos_caracteres+="${lista_caracteres[$index]}"
        done

        # Guardo en una lista de arrays todos los caracteres numeros que voy a emplear y aleatorizar cuando vaya a generar la contraseña.
        lista_numeros=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
        nuevos_numeros=""

        # Le pido al usuario que introduzca la cantidad de números que quiere añadir a la contraseña.
        read -p "Cuantos números quieres añadir a tu password? (Ej:7) --> " agregar_numeros

        # En base a la respuesta que me dio el usuario en la variable agregar_numeros, aleatorizo un numero, si el usuario me dijo 3 pues serán 3 numeros random
        for ((i=0; i<agregar_numeros; i++)); do
            index=$((RANDOM % 10))
            nuevos_numeros+="${lista_numeros[$index]}"
        done

        echo "Reforzando contraseña..."
        sleep 1.5

        # Uno en una sola variable 3 cosas: Los números random + La contraseña que quiere reforzar el usuario + Los caracteres random.
        contrasena_reforzada_final="$nuevos_numeros$contrasena_reforzar$nuevos_caracteres"

        # Imprimo la contraseña en pantalla.
        echo "$contrasena_reforzada_final"

        ;;



    # Opción 3: Ver contraseñas guardadas en el almacén de contraseñas
    3)
        echo "Buscando contraseñas..."
        sleep 1.5

        # Imprimo las contraseñas guardadas hasta ahora en el almacén.
        echo "Estas son las contraseñas que has almacenado:"
        cat "/almacen_contrasenas.txt"
        ;;



    # Opción 4: Guardar contraseña en el almacén de contraseñas
    4)
        # Le pregunto al usuario cual es la contraseña que quiere guardar.
        read -p "Escribe la nueva contraseña que quieres guardar --> " guardar_nueva_contrasena

        # Le pido un nombre para poder asociar la credencial en futuras ocasiones.
        read -p "Asignale una etiqueta (Ej: Amazon_Password) --> " etiqueta_contrasena

        # Uno la contraseña y la etiqueta en una sola variable.
        contrasena_final="$etiqueta_contrasena : $guardar_nueva_contrasena"

        # Guardo esa variable en el archivo de credenciales.
        echo "$contrasena_final" >> /almacen_contrasenas.txt
        echo "Ok. Contraseña guardada."

        # Le pregunto al usuario si quiere ver las credenciales del almacén.
        read -p "¿Quieres ver tus contraseñas guardadas? (/almacen_contrasenas.txt) (s/n) --> " ver_contenedor
        if [ "$ver_contenedor" == "s" ]; then
            echo "Mostrando contraseñas..."
            sleep 1.5
            cat "/almacen_contrasenas.txt"

        # Si el usuario no quiere guardar la contraseña termino esta primera opción del programa usando un exit.
        elif [ "$ver_contenedor" == "n" ]; then
            echo "Ok. No se mostrarán las contraseñas"
        else 
            echo "Opción invalida. Vuelve a intentarlo."
        fi
        ;;



    # Opción 5: Encriptar y securizar el almacén de contraseñas"
    5)
        # Le pido al usuario que ingrese una credencial para cifrar el archivo almacén.
        echo "Elige una contraseña para encriptar /almacen_contrasenas.txt:"
        # Uso la herramienta openssl para encriptar con AES256 todo el contenido del archivo de texto y genero un nuevo archivo llamado almacen_contrasenas.enc.
        openssl enc -aes-256-cbc -salt -in /almacen_contrasenas.txt -out /almacen_contrasenas.enc
        echo "Listo. Importante: No te olvides de guardar esta contraseña en un lugar seguro!"
        ;;

    

    # Opción 6: Desencriptar el almacén de contraseñas
    6)
        # Le pido al usuario que ingrese la contraseña que usó en la opción anterior para descifrar el archivo almacen_contrasenas.enc.
        echo "Introduce la contraseña que elegiste para desencriptar /almacen_contrasenas.enc:"
        openssl enc -d -aes-256-cbc -in /almacen_contrasenas.enc -out /almacen_contrasenas_enc_desencriptado.txt
        ;;



    *)
    # Opción por defecto. En caso de que el usuario elija una opción inexistente le muestro este mensaje.
        echo "Opción invalida. Vuelve a intentarlo."
esac


# Mensaje final
echo ""
echo "Fin del programa."
echo ""



