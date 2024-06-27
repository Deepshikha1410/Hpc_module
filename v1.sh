#!/bin/bash

# ask for the Vtune module
read -p "Enter the vtune_module: " vtune_module

# load the module
module load $vtune_module


# ask for the project directory path
read -p "Enter the path: " project_dir

# check condition for project dir
if [ ! -d "$project_dir" ]; then
  echo "'$project_dir' does not exist."
  exit 1
fi

# ask for the executable path 
read -p "Enter the executable file: " executable_file

# check condition for executable path
if [ ! -f "$executable_file" ]; then
  echo "'$executable_file' does not exist."
  exit 1
fi

# create report
report_dir="$project_dir/report"
mkdir -p "$report_dir"

# final command
vtune --collect=hotspot --result-dir="$report_dir" -- "$executable_file"

# report open command
vtune-gui "$report_dir"
echo "vtune report generated in '$report_dir'"
exit 0