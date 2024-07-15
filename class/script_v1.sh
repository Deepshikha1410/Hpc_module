#!/bin/bash

module load advisor/latest

echo "Enter the Generation name: "
read gen_name



gen_name1=("xehpg_256xve" "xehpg_512xve" "gen12_tgl" "gen12_dg1" "gen11_icl" "gen9_gt2" "gen9_gt3" "gen9_gt4")

while true; do
    valid_gen_name=false
    
    for valid_name in "${gen_name1[@]}"; do
        
        if [ "$gen_name" == "$valid_name" ]; then
            valid_gen_name=true
            echo "Enter the full path to store the file: "
            read file_path

            echo "Enter the Project name for execution: "
            read project_name
        
        fi
    done

    if $valid_gen_name; then
        
        advisor --collect=offload --config=$gen_name --project-dir=$file_path ./$project_name

        
        if [ -f "$file_path/e000/report/advisor-report.html" ]; then
           
            xdg-open "$file_path/e000/report/advisor-report.html"
        
        else
         
            echo "Error: HTML file not generated."
        fi
        
        break
    
    else
        echo "Error: Invalid generation name. Please try again."
        
        echo "Enter the Generation name: "
        read gen_name
        
        echo "Enter the full path to store the file: "
        read file_path

        echo "Enter the Project name for execution: "
        read project_name
        break
    fi
done