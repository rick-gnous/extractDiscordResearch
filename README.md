# extractDiscordResearch

Script Bash & Python pour extraire dans un fichier json les résultats d’une recherche Discord

## Initialisation

Installer les packets `curl` et `brotli`.

    sudo apt install curl brotli


## Utilisation

Garder `help.py` et `extract.sh` au meme niveau et exécuter `extract.sh` depuis son dossier avec `./extract.sh`.

Aller dans Discord où vous sohaitez faire la recherche, faites `Ctrl + Shift + i` et allez dans **Network**. Faites ensuite votre recherche dans la barre de Discord. Vous pourrez alors voir une requete apparaitre dans l’onglet **Network** commencant par `search?has=...`. Faites un clique droit dessus puis cliquer Copy > Copy as curl. 

Lorsque vous lancez le script, il vous ai demandé d’entrer la requete curl. **Il faut supprimer le dernier argument de la requete (`--compressed`).**

Lancer et récupérer le résultat dans `result.json`.
