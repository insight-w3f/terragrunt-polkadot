#!/usr/bin/env bash
TG_FILES=$(find . -type f -name 'terragrunt.hcl')

TG_FILE=("${TG_FILES[@]:2}")

for f in $TG_FILE
do
  echo $f
  cat $f | grep -oP '(?<=.git\?ref\=).*(?=\")'
done
