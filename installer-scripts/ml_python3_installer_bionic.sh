#!/bin/bash
#A script to install python libraries for machine learning and Spyder3

echo "This script installs various Python3 libraries for machine learning."
echo "Do you want to continue? (yes/no)"

read answer

case $answer in
        [Yy]*)
		echo -e "Install libraries and Spyder3 \n"
		#Installation of python libraries for machine learning
		sudo -H pip3 install cmake numpy scipy matplotlib pyyaml \
			h5py pydot-ng opencv-python keras jupyter pillow \
			python-dateutil
		sudo -H pip3 install tensorflow
		
		#Installation of Spyder3
		sudo -H pip3 install PyQtWebEngine spyder

                break
                ;;
        [Nn]*)
                echo -e "Run this script later.\n"
                exit
                ;;
        *)
                echo -e "Type yes or no.\n"     
                ;;
esac


