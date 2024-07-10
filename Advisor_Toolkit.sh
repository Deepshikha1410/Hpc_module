#!/bin/bash

# Function to check for valid GPU config
function valid_config() {
  local config="$1"
  case "$config" in
    xehpg_256xve | xehpg_512xve | gen12_tgl | gen12_tg1 | gen11_icl | gen9_gt2 | gen9_gt3 | gen9_gt4 ) return 0 ;;
    * ) return 1 ;;
  esac
}

# List available advisor modules
echo "Available Advisor Modules:"
module avail | grep advisor
echo ""

# Ask user to select a module
read -p "Select Advisor Module: " advisor_module

# Load the selected module
module load "$advisor_module"

# Ask user for config (target GPU name)
while true; do
  read -p "Enter GPU Config (xehpg_256xve | xehpg_512xve | gen12_tgl | gen12_tg1 | gen11_icl | gen9_gt2 | gen9_gt3 | gen9_gt4): " config
  if valid_config "$config"; then
    break
  else
    echo "Invalid config! Please enter a valid option."
  fi
done

# Ask user for compilation options
read -p "Do you want to compile the code? (y/n): " compile

if [[ "$compile" == "y" ]]; then
  # Ask user for the path to the source file (C/C++)
  read -p "Enter Path to Source File (.c or .cpp): " source_file

  # Get desired output name for compiled executable
  read -p "Enter Output Name for Compiled Executable: " output_name

  # Compile the source file based on extension
  if [[ "${source_file##*.}" == "c" ]]; then
    gcc -o "$output_name" "$source_file"
  elif [[ "${source_file##*.}" == "cpp" ]]; then
    g++ -o "$output_name" "$source_file"
  else
    echo "Unsupported file type. Exiting."
    exit 1
  fi
  executable="$output_name"
else
  # Ask user for the path to the existing executable file
  read -p "Enter Path to Executable File: " executable
fi

# Check if executable file exists
if [ ! -f "$executable" ]; then
  echo "Executable file not found at $executable"
  exit 1
fi

# Ask user for the path to the project directory
while true; do
  read -p "Enter Project Directory Path: " project_dir
  if [ -d "$project_dir" ]; then
    break
  else
    echo "Project directory not found at $project_dir"
  fi
done

# Create the advisor command with user input 
echo "advisor --collect=offload --config=$config --project-dir=./$project_dir -- ./executable_file"
advisor --collect=offload --config="$config" --project-dir="./$project_dir" -- ./"$executable"


# Check if advisor report exists and handle accordingly
if [ ! -f "$project_dir/advisor.html" ]; then
  echo "Advisor report not found at $project_dir/advisor.html"
  echo "**Possible reasons:**"
  echo "  * Errors during execution. Check advisor output for details."
  echo "  * Report might not be generated for specific configurations."
else

# Open Advisor report
xdg-open "$project_dir/e000/report/advisor-report.html"  || echo "Failed to open the Advisor report."
echo "Script execution completedDone!"