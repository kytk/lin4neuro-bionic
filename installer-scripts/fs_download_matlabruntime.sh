#!/bin/bash

#This script is based on 
#https://surfer.nmr.mgh.harvard.edu/fswiki/MatlabRuntime

# 26 Jan 2018 K.Nemoto

#Check if $FREESURFER_HOME is defined
if [ -e $FREESURFER_HOME ]; then 
    echo '$FREESURFER_HOME exists.'
else 
    echo '$FREESURFER_HOME does not exist. Setup FreeSurfer first. exit with error.'
    exit1
fi

#Check OS
os=$(uname)

#install curl for Ubuntu
if [ $os == "Linux" ]; then
    echo "Install a downloader curl"
    sudo apt install curl
elif [ $os == "Darwin" ]; then 
    "proceed to download Matlab runtime"
else
    echo "Cannot detect your OS!"
    exit 1
fi


#Download the runtime

echo "Download MATLAB Runtime"
cd ~/Downloads
curl "https://surfer.nmr.mgh.harvard.edu/fswiki/MatlabRuntime?action=AttachFile&do=get&target=runtime2012bLinux.tar.gz" -o "runtime2012b.tar.gz"

#Unpack the runtime
cd $FREESURFER_HOME
sudo tar xvf ~/Downloads/runtime2012b.tar.gz

echo "Runtime was installed successfully. Exit."
echo "You may delete ~/Downloads/runtime2012b.tar.gz"

sleep 5

exit

