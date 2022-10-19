#!/bin/bash
: '
This script is a helper for Quill v0.2.17.
It has been developed on bash 5.1.16. MacOS is known to have an outdated version
of bash (v3.2.57 on Catalina), so please inform the author if you notice bad
behaviour or an outcome that seem incorrect.

See https://github.com/dfinity/quill for more informations about quill.

Author: Fabio Bonfiglio <fabio.bonfiglio@protonmail.ch>
'

ls *.pem > /dev/null || $(echo "No private key file (.pem) found in current directory." && exit -1)
ls -1 *.pem > files.txt && mapfile KEYFILES < files.txt && rm files.txt
echo "'neurom' v0.1.0 - helper neuron manager script for quill, by F. Bonfiglio"
echo -e "\nPrivate keys found:\n"
for i in "${!KEYFILES[@]}"; do
  printf "\t %s. %s" "$(($i+1))" "${KEYFILES[$i]}"
  #echo -e -n "\t$(($i+1)). ${KEYFILES[$i]}"
done
echo -e -n "\nSelect which one to use: "
read keyf
ind=$(($keyf-1))
echo $keyf
KEYFILE=$KEYFILES[$ind] && echo -e "Using ${KEYFILE}"
echo $KEYFILE
