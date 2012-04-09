#!/bin/bash 

### MAIN ###
# INIT OPTION(command line argv)
while getopts "c:g:" opt; do
case $opt in
c)
    CONFFILE=${OPTARG}
    CONFFLAG=1
    ;;
g)
    GENE=${OPTARG}
    GENEFLAG=1
    ;;
\?)
    echo 'Usage: getopts.sh [OPTION]... '
;;
esac
done


