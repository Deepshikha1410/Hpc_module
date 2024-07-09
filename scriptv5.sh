#!/bin/bash
    module load advisor/latest
    echo "enter  source file .c or.cpp: "
    read source_file

    echo "enter  output file name: "
    read output_name

    if [[ $source_file == *.c ]]; then
        gcc -o $output_name $source_file
    elif [[ $source_file == *.cpp ]]; then
        g++ -o $output_name $source_file
    else
        echo "invalid source file now enter .c or .c++ file"
        exit 1
    fi

    executable_path=$output_name

    echo "enter  executable file path: "
    read executable_path

    echo "enter target device name: "
    read target_device

    echo "enter folder path: "
    read report

    advisor --collect=offload --config=$target_device --project-dir=$report -- $executable_path