import argparse
import json

######################
# INITIALISATION DES #
#     VARIABLES      #
######################
__author__ = "rick@gnous.eu"
__licence__ = "GLP3 or later"

parser = argparse.ArgumentParser(
        description="Outil pour manipuler le fichier JSON des recherches discord"
        )
parser.add_argument('-g', '--getelem', action="store_true", 
        help="Retourne le nombre d’éléments du fichier json")
parser.add_argument('-u', '--updatejson', action="store_true", 
        help="Met à jour le fichier json avec les nouvelles infos")
args = parser.parse_args()

if args.getelem:
    with open("/tmp/file-tmp", 'r') as file:
        data = json.load(file)
    print(data["total_results"])
elif args.updatejson:
    with open("/tmp/file-tmp", 'r') as file:
        data = json.load(file)
    with open("result.json", 'r+') as file:
        oldData = json.load(file)
        for messages in data["messages"]:
            oldData["messages"].append(messages)
        file.seek(0)
        json.dump(oldData, file, indent=4)
