#!/bin/bash

# run with "./generate.sh <wordlist>"
# make sure you have "ripgrep" installed
WORDLIST=$1

# 1. make our "lookup" dictionary (lower cased unique words without punctuation from system dictionary file)
rg "[a-zA-Z]{3,99}$" /usr/share/dict/american-english | tr '[:upper:]' '[:lower:]' | sort | uniq > /tmp/dict-lower
echo "Created /tmp/dict-lower"

# 2. find all wordlist lines ending with a word in our "lookup" dictionary
rm all_prefixes.txt
cat /tmp/dict-lower | while read line; do
  echo "prefix $line"
  rg -io ".*$line\$" $WORDLIST | tr '[:upper:]' '[:lower:]' | sed "s/$line//g" >> all_prefixes.txt
done;
echo "Created all_prefixes.txt"

# 3. find all wordlist lines starting with a word in our "lookup" dictionary
rm all_suffixes.txt
cat /tmp/dict-lower | while read line; do
  echo "suffix: $line"
  rg -io "^$line.*" $WORDLIST | tr '[:upper:]' '[:lower:]' | sed "s/$line//g" >> all_suffixes.txt
done;
echo "Created all_suffixes.txt"

echo "Sorting and counting..."
sort all_prefixes.txt | sed '/^$/d' | uniq -c | sort -nr > prefixes.txt
sort all_suffixes.txt | sed '/^$/d' | uniq -c | sort -nr > suffixes.txt
echo "Created prefixes.txt and suffixes.txt"
