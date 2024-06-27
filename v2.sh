#!/bin/bash

# load the module
read -p "Enter the vtune_module: " vtune_module
module load $vtune_module

# ask for project directory path 
read -p "Enter the path: " project_dir

#check condition for poject dir
if [ ! -d "$project_dir" ]; then
  echo "Project directory does not exist"
  exit 1
fi

# run application1 
source_file1="mmlt_with_opt.c"
executable_file1="mmult_with_opt"
gcc -o $executable_file1 $source_file1
vtune --collect=hotspot --result-dir=$project_dir/report1 -- ./$executable_file1

# run application2
source_file2="mmult_without_opt.c"
executable_file2="mmult_without_opt"
gcc -o $executable_file2 $source_file2
vtune --collect=hotspot --result-dir=$project_dir/report2 -- ./$executable_file2

# Compare the results
vtune -report hotspots -r $project_dir/report1 -r $project_dir/report2 \
  --column="Result 1:CPU Time:Self" --column="Result 2:CPU Time:Self"

# Show increase/decrease in hotspot time
vtune -report hotspots -r $project_dir/report1 -r $project_dir/report2 \
  --column="Result 1:CPU Time:Self" --column="Result 2:CPU Time:Self" \
  --show-diff=true