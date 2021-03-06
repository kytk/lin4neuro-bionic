#!/bin/bash

#Part3: Check if software is installed.

log=$(date +%Y%m%d%H%M%S)-part3.log
exec &> >(tee -a "$log")


echo "Check if neuroimaging software is properly installed."


#Slicer
#echo "Run Slicer"
#Slicer &
#wait

#Aliza
echo "Run Aliza"
aliza &
wait

#c3d
echo "Run c3d"
c3d -h

#DSI Studio
echo "Run DSI-Studio"
/usr/local/dsistudio/dsi_studio &
wait

#ITK-SNAP
echo "Run itksnap"
itksnap &
wait

#Mango
echo "Run Mango"
/usr/local/Mango/mango &
wait

#MRIcroGL
echo "Run MRIcroGL"
MRIcroGL &
wait

#dcm2niix
echo "Run dcm2niix"
dcm2niix

#MRIcron
echo "Run MRIcroN"
mricron &
wait

#ROBEX
echo "Run ROBEX"
ROBEX

#Virtual MRI
echo "Virtual MRI"
java -jar /usr/local/vmri/vmri.jar
wait


echo "Finish checking!"

exit

