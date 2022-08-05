# Quill Guide
💾 <version>v1.0</version>

## Installation
Suivre la procédure [ici](https://github.com/dfinity/quill) (compiler ou [télécharger une bin](https://github.com/dfinity/quill/releases) déjà prête).

## Syntaxe complète
Copiée de `quill --help`:
```
Ledger & Governance ToolKit for cold wallets

USAGE:
    quill-linux-x86_64 [OPTIONS] <SUBCOMMAND>

OPTIONS:
    -h, --help                         Print help information
        --hsm                          
        --hsm-id <HSM_ID>              
        --hsm-libpath <HSM_LIBPATH>    
        --hsm-slot <HSM_SLOT>          
        --insecure-local-dev-mode      Fetches the root key before making requests so that
                                       interfacing with local instances is possible. DO NOT USE WITH
                                       ANY REAL INFORMATION
        --pem-file <PEM_FILE>          Path to your PEM file (use "-" for STDIN)
        --qr                           Output the result(s) as UTF-8 QR codes
        --seed-file <SEED_FILE>        Path to your seed file (use "-" for STDIN)
    -V, --version                      Print version information

SUBCOMMANDS:
    account-balance             Queries a ledger account balance
    claim-neurons               Claim seed neurons from the Genesis Token Canister
    generate                    Generate a mnemonic seed phrase and generate or recover PEM
    get-neuron-info             
    get-proposal-info           
    help                        Print this message or the help of the given subcommand(s)
    list-neurons                Signs the query for all neurons belonging to the signing
                                    principal
    list-proposals              
    neuron-manage               Signs a neuron configuration change
    neuron-stake                Signs topping up of a neuron (new or existing)
    public-ids                  Prints the principal id and the account id
    qr-code                     Print QR code for data e.g. principal id
    replace-node-provider-id    Signs a message to replace Node Provide ID in targeted Node
                                    Operator Record
    scanner-qr-code             Print QR Scanner dapp QR code: scan to start dapp to submit QR
                                    results
    send                        Sends a signed message or a set of messages
    transfer                    Signs an ICP transfer transaction
    update-node-provider        Update node provider details
```
Pour chaque subcommand, on peut obtenir de l'aide supplémentaire, par exemple pour `send`, taper `quill send --help`.

## Principe
Par exemple, pour demander la liste des neurones managés par une clé privée, taper la ligne suivante
```bash
quill --pem-file maClePrivee.pem list-neurons > /tmp/req.json && quill send --yes /tmp/req.json ; rm /tmp/req.json
```
Il y a en réalité 3 commandes qui sont exécutées:  
1. `quill --pem-file $PEM_FILE list-neurons > /tmp/req.json`: Signe une transaction pour demander une liste des neurons managés pour la clé indiquée, et enregistre le résultat dans un fichier temporaire (`/tmp/req.json`).  
2. `quill send --yes /tmp/req.json`: Envoie au résau la transaction signée, et ne demande pas de confirmation (option `--yes`) car c'est une opération peu risquée.  
3. `rm /tmp/req.json`: Supprime immédiatement le fichier contenant la transaction signée, par sécurité.

L'opérateur `&&`, qui est entre les deux premières commandes, sert à indiquer que le terminal ne doit exécuter la commande suivante que si la précédente a réussi sans erreur. Alors que l'opérateur `;` sert à indiquer que le terminal doit exécuter la commande suivante, une fois la précédente terminée, même si celle-ci a résulté en erreur.

> ℹ Pour chacune des commandes `send` ci-dessous, un _test à blanc_ peut être réalisé pour vérifier que la commande va bien exécuter ce qu'on désire. Il suffit de rajouter l'option `--dry-run` à la commande `send` (par exemple à la place du `--yes` à l'étape 2 ci-dessus).

> ℹ Le répertoire système `/tmp` est normalement automatiquement vidé à l'extinction de l'ordinateur, mais il est conseillé de tout de même vérifier de temps à autres s'il ne resterait pas une transaction signée là-dedans!

## Scénarios courants
Pour chaque scénario, un exemple de commande directe est d'abord représenté. La commande utilise des variables, qui permettent d'éviter de devoir taper plusieurs fois les mêmes éléments dans les cas où on aimerait réaliser plusieurs opérations d'affilée.  
Si on a qu'une seule opération à effectuer, on peut simplement entrer les informations à la place du nom de ces variables dans les commandes.

#### Réglage des variables
Taper la commande suivante pour régler une variable contenant le chemin de la clé privée:
```bash
PEM_FILE="cleprivee.pem"
```
Et pour un neuron sur lequel on aimerait faire plusieurs opérations:
```bash
NEURONID=<IDENT>
```
Remplacer `<IDENT>` par le Neuron ID.

### Stake on a (new or existing) neuron
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-stake --amount 42.2 --name neuron1 > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Stakera 42.2 ICP sur le neuron nommé _neuron1_.

### Increase dissolve delay
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage -a 15552000 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Ajoutera 6 mois (15'552'000 secondes) de dissolve delay au neuron.

### Increase stake
Voir la commande de stake [ci-dessus](#stake-on-a-new-or-existing-neuron).

### Generate a hot-key
For monitoring from (https://nns.ic0.app/) with another PrincipalID:

> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --add-hot-key <PrincipalID> $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Merge a neuron maturity
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --merge-maturity 100 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Mergera 100% de la maturité dans le neuron.

### Merge two neurons
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --merge-from-neuron <IDENT2> $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
Remplacer `<IDENT2>` par le neuronID qui doit être mergé dans le neurone managé (variable `$NEURONID`).  
Le stake entier, toute la maturité, ainsi que l'âge du neuron `<IDENT2>`, seront mergés.

### Spawn a neuron from maturity
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --spawn $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```

### Split a neuron
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --split 12 $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
12 ICP seront splités du neuron spécifié, dans un nouveau neuron.

### Participate in community fund
> ⚠ Non testé !

```bash
quill --pem-file $PEM_FILE neuron-manage --join-community-fund $NEURONID > /tmp/req.json && quill send /tmp/req.json ; rm /tmp/req.json
```
