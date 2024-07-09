echo "Compile C/C++ code"
echo "1. Compile C code"
echo "2. Compile C++ code"
read -p "Enter the choice: " compile_choice

case "$compile_choice" in
  1)
    echo "Enter the C source file (.c): "
    read c_file
    echo "Enter the output file name: "
    read output_name
    if [ -f "$c_file" ]; then
      gcc -o "$output_name" "$c_file"
      echo "Compilation successful!"
    else
      echo "Error: $c_file not found."
    fi
    ;;
  2)
    echo "Enter the C++ source file (.cpp): "
    read cpp_file
    echo "Enter the output file name: "
    read output_name
    if [ -f "$cpp_file" ]; then
      g++ -o "$output_name" "$cpp_file"
      echo "Compilation successful!"
    else
      echo "Error: $cpp_file not found."
    fi
    ;;
  *)
    echo "Invalid choice."
    ;;
esac