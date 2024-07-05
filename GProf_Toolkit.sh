#!/bin/bash

# Enter the file name
echo "Enter the file name:"
read filename

# Enter executable filename
read -p "Enter executable filename: " exe_filename

# Compile the file with profiling flags
gcc -pg -o "$exe_filename" "$filename.c"

# Run the executable to generate gmon file
./"$exe_filename"

# Convert gmon file to human-readable format
gprof "$exe_filename" gmon.out > "report_file.txt"

# Report generated
echo "Profiling report generated in report_file.txt"