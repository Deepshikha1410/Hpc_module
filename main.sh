#!/bin/bash

echo "Welcome to Profiling Toolkit"
echo "Below are the list of Toolkit"
echo "1. Advisor Toolkit"
echo "2. VTune Toolkit"
echo "3. HPCToolkit"
echo "4. Gprof Toolkit"
echo "5. Exit"

read -p "Select the option: " select

case $select in
  1)
    echo "Please wait Advisor Toolkit on the way"

        ./Advisor_Toolkit.sh
        ;;
  2)
    echo "VTune Toolkit will show you hotspots"

        ./VTune_Toolkit.sh
        ;;
  3)
    echo "HPC Toolkit will based on events"

        ./HPC_Toolkit.sh
        ;;
  4)
    echo "GProf this will give you result jaldi"

        ./GProf_Toolkit.sh
        ;;
  5)
    echo "Visit krne ke liye shukriya.Dubara aiyega"
    
        exit 0
        ;;
  *)
    echo "Invalid: Ankho ki checkup krwaye, galat option select kiye hai apne"
        ;;
esac
