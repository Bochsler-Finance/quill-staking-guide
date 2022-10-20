#!/bin/bash
: '
This script is a helper for Quill v0.2.17.
It has been developed on bash 5.1.16. MacOS is known to have an outdated version
of bash (v3.2.57 on Catalina), so please inform the author if you notice bad
behaviour or an outcome that seem incorrect.

See https://github.com/dfinity/quill for more informations about quill.
'
VERSION="0.1.0"
AUTHOR="Fabio Bonfiglio <fabio.bonfiglio@protonmail.ch>"

printf "%b\n" "'\033[1mneurom\033[0m' v${VERSION} - helper neuron manager script for \033[1mquill\033[0m, by ${AUTHOR}"
ls *.pem &> /dev/null || NOKEY=1
if [[ $NOKEY -eq 1 ]]; then
  printf "\n%s\n" "No private key file (.pem) found in current directory."
  exit -1
fi
#ls -1 *.pem | mapfile KEYFILES
#ls -1 *.pem | read -ra KEYFILES
ls -1 *.pem > files.txt && mapfile KEYFILES < files.txt && rm files.txt
printf "\n%s\n\n" "Private keys found:"
for i in "${!KEYFILES[@]}"; do
  printf "\t %s. %s" "$(($i+1))" "${KEYFILES[$i]}"
done
if [[ ${#KEYFILES[@]} -gt 1 ]]; then
  RANGESTR="Type (1 - ${#KEYFILES[@]}) to select which one to use"
else
  RANGESTR="Type 1 to use it"
fi
VALIDENTRY=0
while [[ $VALIDENTRY -eq 0 ]]; do
  printf "\n%s" "${RANGESTR}, or CTRL+C to cancel: "
  read -rN 1 keyf
  if [[ $keyf =~ ([1-9]+) ]]; then
    if [[ $keyf -gt ${#KEYFILES[@]} ]]; then
      printf "\n%s" "Bad selection (${keyf} is not a valid entry)"
    else
      VALIDENTRY=1
    fi
  else
    printf "\n%s" "Please enter a numerical value !"
  fi
done
ind=$(($keyf-1))
KEYFILE=${KEYFILES[$ind]} && printf "\n%b\n" "Using \033[1m${KEYFILE}\033[0m"
quill --pem-file ${KEYFILE} public-ids
printf "\n%s\n" "Requesting neuron list..."
quill --pem-file ${KEYFILE} list-neurons | quill send --yes - > neurons.txt
cat neurons.txt | grep "neuron_infos"
