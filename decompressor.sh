#!/usr/bin/env bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

echo -e "${greenColour}\t--------------------------- Decompresing ---------------------------\n${endColour}"
names=$(7z l pedro | grep "Name" -A 2 | tail -n 1 | xargs | awk 'NF{print $NF}')
echo -e "${blueColour}\t[+]${endColour} ${grayColour}file: ${endColour} ${purpleColour}pedro${endColour}"
7z x pedro &>/dev/null

name_oa=$(7z l $names | grep "Name" -A 2 | tail -n 1 | xargs | awk 'NF{print $NF}')
echo -e "${blueColour}\t[+]${endColour} ${grayColour}file: ${endColour} ${purpleColour}$names${endColour}"
7z x $names &>/dev/null
code_status=$?

while [ $code_status -eq 0 ]; do

  echo -e "${blueColour}\t[+]${endColour} ${grayColour}file: ${endColour} ${purpleColour}$name_oa${endColour}"
  7z x $name_oa &>/dev/null
  code_status=$?
  last_name=$name_oa
  name_oa=$(7z l $name_oa | grep "Name" -A 2 | tail -n 1 | xargs | awk 'NF{print $NF}')

done

echo -e "${greenColour}\t[+] Opening the ${endColour}${grayColour}$last_name${endColour}${greenColour} file${endColour}"
password=$(cat $last_name | awk 'NF{print $NF}')
echo -e "${greenColour}\t[+] password = ${endColour}${blueColour}$password${endColour}"
