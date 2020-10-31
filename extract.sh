#!/bin/bash

#***************************#
#         extract.sh        #
#                           #
#   author : rick@gnous.eu  #
#   licence: GPL3 or later  #
#                           #
#***************************#


################################################################################
# Télécharge le fichier .b se trouvant à l’url en paramètre et le dézip dans
# /tmp/file-tmp.
# Globals:
#     [TODO:var-name]
# Arguments:
#     $1: le curl (sans de --output) à faire pour récupérer le fichier
################################################################################
function recupDezip {
    command="$@ --output /tmp/file-tmp.b"
    eval $command
    
    if [ -f "/tmp/file-tmp" ]
    then
        rm /tmp/file-tmp
    fi
    
    brotli -d -S .b /tmp/file-tmp.b
}

read -p "Entrez commande curl sans --compressed : " commandCurl

recupDezip $commandCurl

# on récupère le nombre de résultat pour avoir le nombre de page
nbResult=$(python3 help.py -g)
nbPage=$((nbResult / 25))
url=$(echo $commandCurl | cut -d\  -f2)
args=$(echo $commandCurl | cut -d\  -f3-)
url="${url::-1}&offset=${url: -1}"

if [ $((nbResult % 25)) -gt 0 ]
then
    nbPage=$((nbPage + 1))
fi

read -p "Attention ! $nbPage pages seront traités !"

if [ -f result.json ]
then
    rm result.json
fi
cp /tmp/file-tmp result.json

j=25
for i in $(seq 1 $nbPage)
do
    newUrl="${url::-1}$j${url: -1}"
    newCommand="curl $newUrl $args"
    recupDezip $newCommand
    python3 help.py -u
    j=$((j + 25))
done

echo $nbPage
