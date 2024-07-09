#!/bin/bash

while true; do
  echo "advisor Script"
  echo "1. run advisor to load particular module advisor/latest"
  echo "2. run advisor  avialabe from list"
  echo "3. exit"
  read -p "enter the choice: " choice

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
      ;;
    2)
      while true; do
        echo "Enter the generation name : "
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

      echo "Enter the full path to store file : "
      read store_path

      echo "Enter the file name"
      read file_name

      module load advisor/latest
      advisor --collect=offload --config=$gen --project-dir=./$store_path -- ./$file_name
      ;;
    3)
      exit
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done