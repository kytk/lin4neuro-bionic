#!/bin/bash
#A script to install python libraries for machine learning and Spyder3

#Installation of python libraries for machine learning
sudo apt-get -y install build-essential pkg-config              \
        libopenblas-dev liblapack-dev libhdf5-serial-dev graphviz 
sudo apt-get -y install python3-venv python3-pip python3-dev    \
        python3-tk      
sudo -H pip3 install cmake numpy scipy matplotlib pyyaml h5py   \
        pydot-ng opencv-python keras jupyter pillow python-dateutil
sudo -H pip3 install tensorflow

#Installation of Spyder3
sudo -H pip3 install PyQtWebEngine spyder

