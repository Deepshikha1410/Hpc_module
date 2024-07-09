#!/bin/bash

while true; do
  echo "Advisor Script"
  echo "1. Run advisor to load particular module advisor/latest"
  echo "2. Run advisor available from list"
  echo "3. Check executable and directory path"
  echo "4. Compile and run advisor"
  echo "5. Exit"
  read -p "Enter the choice: " choice

  case "$choice" in
    1)
      echo "Enter the target device name:"
      read target_device

      echo "Enter the path of the executable file:"
      read executable_path

      echo "Enter the path of the folder to generate report:"
      read report

      module load advisor/latest
      advisor --collect=offload --config=$target_device --project-dir=$report -- $executable_path

      echo "Opening report in Firefox..."
      xdg-open $report/index.html
      ;;
    2)
      while true; do
        echo "Enter the generation name: "
        read gen

        case "$gen" in
          ("xehpg_256xve" | "xehpg_512xve" | "gen12_tgl" | "gen12_tg1" | "gen11_icl" | "gen9_gt2" | "gen9_gt3" | "gen9_gt4")
            break
            ;;
          *)
            echo "The name $gen is not available. Please try again."
            ;;
        esac
      done

      echo "Enter the full path to store file: "
      read store_path

      echo "Enter the file name:"
      read file_name

      module load advisor/latest
      advisor --collect=offload --config=$gen --project-dir=./$store_path --./$file_name

      echo "Opening report in Firefox..."
      xdg-open $store_path/index.html
      ;;
    3)
      echo "Enter executable path: "
      read executable_path

      if [ ! -x "$executable_path" ]; then
        echo "Executable $executable_path does not exist or is not executable."
        exit 1
      fi

      echo "Enter directory path: "
      read directory_path

      if [ ! -d "$directory_path" ]; then
        echo "Directory $directory_path does not exist."
        exit 1
      fi

      echo "Executable and directory path are valid."
      ;;
    4)
      echo "Enter source file (.c or.cpp): "
      read source_file

      echo "Enter output file name: "
      read output_name

      if [[ $source_file == *.c ]]; then
        gcc -o $output_name $source_file
      elif [[ $source_file == *.cpp ]]; then
        g++ -o $output_name $source_file
      else
        echo "Invalid source file. Please enter.c or.cpp file"
        exit 1
      fi

      executable_path=$output_name

      echo "Enter target device name: "
      read target_device

      echo "Enter folder path: "
      read report

      module load advisor/latest
      advisor --collect=offload --config=$target_device --project-dir=$report -- $executable_path

      echo "Opening report in Firefox..."
      xdg-open $report/index.html
      ;;
    5)
      exit
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done