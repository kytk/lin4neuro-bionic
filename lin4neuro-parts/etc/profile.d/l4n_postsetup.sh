#!/bin/bash

grep MRIcroGL ~/.bashrc > /dev/null
if [ $? -eq 1 ]; then
    echo "Install neuroimaging-related software packages"
    ~/git/lin4neuro-bionic/build-l4n-bionic-2.sh
fi

