#! /usr/bin/env bash
echo 'angular.module("'$3'", [])' > $2
echo '.factory("$grammar", [function() {' >> $2

sed "s/Peg\.parser \= /return { parser:/" < $1 | awk 'NR>1{print buf}{buf = $0}' >> $2

echo '})()}' >> $2
echo '}]);' >> $2
