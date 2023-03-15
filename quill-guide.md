---
version: 1.31
author: Fabio Bonfiglio <fabio@bochslerfinance.com>
copyright: Copyright (C) 2023 Bochsler Finance SA
---
# Quill Guide
💾 <version>v1.31</version> pour [`quill` **v0.3.2**](https://github.com/dfinity/quill/releases/tag/v0.3.2)

## Installation
Suivre la procédure [ici](https://github.com/dfinity/quill) (compiler ou [télécharger une bin](https://github.com/dfinity/quill/releases/tag/v0.3.2) déjà prête).

## Syntaxe complète
Pour avoir un aperçu de la syntaxe complète et de toutes les commandes possibles, taper `quill --help`.

Pour chaque subcommand, on peut obtenir de l'aide supplémentaire, par exemple pour `send`, taper `quill help send` ou `quill send --help`.

## Principe
Par exemple, pour demander la liste des neurones managés par une clé privée, on tapera la ligne suivante
```bash
quill list-neurons --pem-file maClePrivee.pem > /tmp/req.json && quill send --yes /tmp/req.json ; rm /tmp/req.json
```
Il y a en réalité 3 commandes qui sont exécutées:  
1. `quill list-neurons --pem-file maClePrivee.pem  > /tmp/req.json`: Signe une transaction pour demander une liste des neurons managés pour la clé indiquée, et enregistre le résultat dans un fichier temporaire (`/tmp/req.json`).  
2. `quill send --yes /tmp/req.json`: Envoie au résau la transaction signée, et ne demande pas de confirmation (option `--yes`) car c'est une opération peu risquée.  
3. `rm /tmp/req.json`: Supprime immédiatement le fichier contenant la transaction signée, par sécurité.

L'opérateur `&&`, qui est entre les deux premières commandes, sert à indiquer que le terminal ne doit exécuter la commande suivante que si la précédente a réussi sans erreur. Alors que l'opérateur `;` sert à indiquer que le terminal doit exécuter la commande suivante, une fois la précédente terminée, même si celle-ci a résulté en erreur.

> ℹ Pour chacune des commandes `send` ci-dessous, un _test à blanc_ peut être réalisé pour vérifier que la commande va bien exécuter ce qu'on désire. Il suffit de rajouter l'option `--dry-run` à la commande `send` (par exemple à la place du `--yes` à l'étape 2 ci-dessus).

> ℹ Le répertoire système `/tmp` est normalement automatiquement vidé à l'extinction de l'ordinateur, mais il est conseillé de tout de même vérifier de temps à autres s'il ne resterait pas une transaction signée là-dedans!

### Variante _pipe_
Au lieu de passer par un fichier intermédiaire contenant la transaction signée, on peut directement la passer à la commande `send` ainsi (à l'aide de l'opérateur [`|`](https://en.wikipedia.org/wiki/Pipeline_(Unix))):
```bash
quill list-neurons --pem-file maClePrivee.pem | quill send --yes -
```
> ℹ Les deux solutions ont leurs avantages et inconvénients en termes de sécurité. Elles sont cependant toutes deux relativement sûres, et dans le cas d'un ordinateur connecté directement au réseau, la variante _pipe_ est plus rapide, mais supprime une étape qui sert également à éviter des erreurs.

## Scénarios courants
Pour chaque scénario, un exemple de commande directe est d'abord représenté. La commande utilise des variables, qui permettent d'éviter de devoir taper plusieurs fois les mêmes éléments dans les cas où on aimerait réaliser plusieurs opérations d'affilée.  
Si on a qu'une seule opération à effectuer, on peut simplement entrer les informations à la place du nom de ces variables dans les commandes.

#### Réglage des variables
Pour gagner du temps, taper la commande suivante pour régler une variable contenant le chemin de la clé privée:
```bash
PEM_FILE="cleprivee.pem"
```
Ou si elle se trouve dans un autre répertoire que celui en cours:
```bash
PEM_FILE="chemin/vers/cleprivee.pem"
```
Par exemple si elle se trouve sur le bureau: `PEM_FILE="Desktop/cleprivee.pem"`.

Et pour un neuron sur lequel on aimerait faire plusieurs opérations:
```bash
NEURONID=<IDENT>
```
Remplacer `<IDENT>` par le Neuron ID.

Ainsi, les commandes ci-dessous pourront être directement copiées-collées sans modification. Pour changer de clés / neurons, il suffit alors de répéter les commandes ci-dessus avec les nouvelles valeurs.

### Stake on a (new or existing) neuron
```bash
quill neuron-stake --pem-file $PEM_FILE --amount 42.2 --name neuron1 > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Stakera 42.2 ICP sur le neuron nommé _neuron1_.

> ⚠ Il y a par défaut 10000 e8s (0.01 ICP) de _fees_ pour staker. Donc s'il il n'y par exemple que 3 ICP (3000000 e8s) sur l'_account_, on ne pourra staker que **2.99 ICP** (2990000 e8s).

### Increase dissolve delay
> ⚠ Non testé !

```bash
quill neuron-manage --pem-file $PEM_FILE -a 15552000 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Ajoutera 6 mois (15'552'000 secondes) de dissolve delay au neuron.

### Increase stake
Voir la commande de stake [ci-dessus](#stake-on-a-new-or-existing-neuron).

### Generate a hot-key
For monitoring from (https://nns.ic0.app/) with another PrincipalID:
```bash
quill neuron-manage --pem-file $PEM_FILE --add-hot-key <PrincipalID> $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Merge a neuron maturity
```bash
quill neuron-manage --pem-file $PEM_FILE --merge-maturity 100 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Mergera 100% de la maturité dans le neuron.

### Merge two neurons
```bash
quill neuron-manage --pem-file $PEM_FILE --merge-from-neuron <IDENT2> $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Remplacer `<IDENT2>` par le neuronID qui doit être mergé dans le neurone managé (variable `$NEURONID`).  
Le stake entier, toute la maturité, ainsi que l'âge du neuron `<IDENT2>`, seront mergés.

### Spawn a neuron from maturity
```bash
quill neuron-manage --pem-file $PEM_FILE --spawn $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
La maturité spawnera un nouveau neuron qui pourra être `disburse` au bout de ~6 jours.

### Split a neuron
```bash
quill neuron-manage --pem-file $PEM_FILE --split 12 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
12 ICP seront splités du neuron spécifié, dans un nouveau neuron.

### Dissolve a neuron
```bash
quill neuron-manage --pem-file $PEM_FILE --start-dissolving $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Stop dissolving
```bash
quill neuron-manage --pem-file $PEM_FILE --stop-dissolving $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Disburse staked ammount
```bash
quill neuron-manage --pem-file $PEM_FILE --disburse $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Retire la totalité du montant staké sur le neuron, dans l'account du propriétaire.

### Transfer disbursed
D'abord régler le montant à transférer, en prévoyant qu'il reste au moins 0.0001 ICP pour les fees:
```bash
AMOUNT=42.20000000
```
Puis l'accountID de destination:
```bash
DESTINATION=f8e0c2801a59b4b53a3b4e5424bbdff2b99f4b36cb41a64b7419850a79e8a94f
```
Et exécuter la commande suiante: 
```bash
quill transfer --pem-file $PEM_FILE --amount $AMOUNT $DESTINATION > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Participate in community fund
```bash
quill neuron-manage --pem-file $PEM_FILE --join-community-fund $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
---
# Commandes terminal
Ce guide suppose l'**utilisation du [terminal](https://www.youtube.com/watch?v=aKRYQsKR46I)**.  
Pour ouvrir le terminal sur MacOS, appuyer sur `cmd`+`space` et taper `terminal` et return.  
Pour ouvrir le terminal sur Linux (Debian, Ubuntu, etc), taper `CTRL`+`ALT`+`T`.  
Pour ouvrir le terminal sous Windows... désinstallez Windows et mettez-vous à Linux !  

## Commandes de base
En cas de besoin, une explication de chacune des commandes ci-dessous peut être obtenue avec `man`.
Par exemple pour la commande `cp`, taper:
```bash
man cp
```
### Lister les fichiers et répertoires du répertoire courant
```bash
ls
```
### Aller dans un répertoire
```bash
cd nomRepertoire
```
### Revenir au répertoire parent
```bash
cd ..
```
### Copier un fichier
```bash
cp nomRepertoire/fichierAcopier repertoireDestination/
```
### Déplacer ou renommer un fichier
```bash
mv fichierSource repertoire/nouveauNom
```
### Afficher le contenu d'un fichier
```bash
less /tmp/req.json
```
ou s'il est petit et qu'on veut l'avoir affiché pendant qu'on tape la prochaine commande:
```bash
cat /tmp/req.json
```
