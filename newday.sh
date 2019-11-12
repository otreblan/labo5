#!/bin/sh

# Un script para crear los archivos para tomar notas de una nueva clase

MAIN="main.tex"

LASTDAY=$(
	git describe --abbrev=0 2>/dev/null |\
	sed "s/v\([0-9]\+\)\.\+[0-9]*/\1/"
)
CURRDAY=$(( LASTDAY + 1 ))
CURRDAY=$( printf %02d $CURRDAY )

IMGDIR=ima/clase${CURRDAY}

# No hace nada si el archivo ya existe
if [[ -e tex/clase${CURRDAY}.tex ]]
then
	echo "Ya existen los archivos de esta clase" >&2
	exit 1
fi

# Esto llena la plantilla con el número de clase actual
CURRDAY=${CURRDAY} envsubst < tex/clase.tex > tex/clase${CURRDAY}.tex

LASTDAY_MACRO="\\\\subfile{tex\/clase${LASTDAY}}"
CURRDAY_MACRO="\\\\subfile{tex\/clase${CURRDAY}}"

# Esto agrega el nuevo archivo como un subfile en el archivo principal
cat main.tex | sed -i "s/$LASTDAY_MACRO/&\n${CURRDAY_MACRO}/g" $MAIN

# Esto crea una nueva carpeta para poner imágenes
if [[ ! -d $IMGDIR ]]; then
	mkdir $IMGDIR
fi
touch ima/clase${CURRDAY}/PLACEHOLDER
