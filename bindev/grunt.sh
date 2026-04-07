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

# Run grunt for amd modules in path.
cd $path
grunt amd --force

# Now purge the caches.
cd $dir
cd ..
./bindev/purge_caches.sh
#./bindev/build_css.sh
