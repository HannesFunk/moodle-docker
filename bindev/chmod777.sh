#!/bin/bash

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while getopts p: flag
do
    case "${flag}" in
        p) path=${OPTARG};
    esac
done

if [[ -z "$path" ]]; then
    echo "-p is not set. Please specifiy the path"
    exit
fi

echo "Starte chmod 777 on $path"

chmod 777 -R $path
