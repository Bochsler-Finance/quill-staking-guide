#!/bin/bash
: '
This script is a helper for Quill v0.3.2.
It has been developed on bash 5.1.16.
MacOS is known to have an outdated version
of bash (v3.2.57 on Catalina), so please inform the author if you notice bad
behaviour or an outcome that seem incorrect.

See https://github.com/dfinity/quill for more informations about quill.

Copyright (C) 2023 Bochsler Finance SA

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
'
VERSION="0.1.1"
AUTHOR="Fabio Bonfiglio <fabio@bochslerfinance.com>"

echo "neurom (Quill Scripted Guide),  Copyright (C) 2023  Bochsler Finance SA"
echo "This is free software, and you are welcome to redistribute it."

printf "%b\n" "'\033[1mneurom\033[0m' v${VERSION} - helper neuron manager script for \033[1mquill\033[0m, by ${AUTHOR}"
ls *.pem &> /dev/null || NOKEY=1
if [[ $NOKEY -eq 1 ]]; then
  printf "\n%s\n" "No private key file (.pem) found in current directory."
  exit -1
fi
#ls -1 *.pem | mapfile KEYFILES
#ls -1 *.pem | read -ra KEYFILES
ls -1 *.pem > files.txt && mapfile -t KEYFILES < files.txt && rm files.txt
printf "\n%s\n\n" "Private keys found:"
for i in "${!KEYFILES[@]}"; do
  printf "\t %s. %s\n" "$(($i+1))" "${KEYFILES[$i]}"
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
quill public-ids --pem-file $KEYFILE
printf "\n%s\n" "Requesting neuron list..."
NEURONSFILE="${KEYFILE%.pem}_neurons.txt"
quill list-neurons --pem-file $KEYFILE  | quill send --yes - > "${NEURONSFILE}"
cat $NEURONSFILE | grep "neuron_infos"
# TBC (remove cat and parse received reply to list neuron ids)
