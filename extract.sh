#!/bin/bash

#***************************#
#         extract.sh        #
#                           #
#   author : rick@gnous.eu  #
#   licence: GPL3 or later  #
#                           #
#***************************#

fichierExtract="/tmp/file-tmp"
fichierB="$fichierExtract.b"
fichierJson="$fichierExtract.json"

################################################################################
# Télécharge le fichier .b se trouvant à l’url en paramètre et le dézip dans
# /tmp/file-tmp.
# Globals:
#     $fichierB: le chemin vers le fichier compressé .b
#     $fichierExtract: le chemin vers le fichier décompressé
# Arguments:
#     $1: le curl (sans de --output) à faire pour récupérer le fichier
################################################################################
function recupDezip {
    command="$@ --output $fichierB"
    eval $command 2> /dev/null

    if [ -f $fichierExtract ]
    then
        rm $fichierExtract
    fi
    
    brotli -d -S .b $fichierB
    if [ $? -eq 1 ]
    then
        sleep 3s
        recupDezip $@
    fi
}

function recupJson {
    command="$@ --output $fichierExtract"
    eval $command 2> /dev/null
}

read -p "Entrez commande curl sans --compressed : " commandCurl

#recupDezip $commandCurl
recupJson $commandCurl

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

echo 
read -p "Attention ! $nbPage pages seront traités !"

if [ -f result.json ]
then
    rm result.json
fi
#cp $fichierExtract result.json
cp $fichierExtract result.json

j=25
for i in $(seq 1 $nbPage)
do
    newUrl="${url::-1}$j${url: -1}"
    newCommand="curl $newUrl $args"
    #recupDezip $newCommand
    recupJson $newCommand
    python3 help.py -u
    j=$((j + 25))
    echo -e "\r$i/$nbPage pages\c"
done
