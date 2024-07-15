#!/bin/bash

module load advisor/latest

echo "Enter the GPU name: "
read gen

echo "Enter the config: "
read store_path

echo "Enter the file name: "
read file_name

advisor --collect=offload --config=$gen --project-dir=$store_path -- $file_name

echo "Report in the folder matrix:"
firefox /home/user4/HPC_intro/Day4/new_report.html