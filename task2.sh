#!/bin/bash
list_dir=()

list_dir=(`ls -l $1 | grep '^d' | sed '/.*_X$/d' |  sed 's/.* \(.*\)$/\1/'`)
for proc in "${list_dir[@]}"
do
    if ps -e | grep $proc | grep -v grep > /dev/null ; then
        echo -e "$proc - \033[1;32mrunning\033[0m"
    else
        echo -e "$proc - \033[1;31mstop\033[0m"
    fi
done

