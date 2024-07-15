#!/bin/bash

# Ask for the generation
read -p "Enter the generation: " generation

# Ask for the directory path
read -p "Enter the directory path: " dir_path

# Ask for the executable path
read -p "Enter the executable path: " exe_path

# Ask for the command
read -p "Enter the command: " command

# Change to the directory path
cd "$dir_path"

# Run the command using the provided input
$command "$exe_path" "$file_name"
