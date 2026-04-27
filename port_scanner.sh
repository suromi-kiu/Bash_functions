#!/usr/bin/env bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "${redColour}[!] Exiting...${endColour}"
  tput cnorm && exit 1
}

trap ctrl_c SIGINT

function help_pannel(){
  echo -e "\n\t${blueColour}-------------------- Suromi's Port Scanner --------------------${endColour}"
  echo -e "\n\t${yellowColour}[+] Usage: ${endColour} ${purpleColour}Write your IP and your PORT by doing :: EX: -i 10.10.10.10 -p 80${endColour}"
  echo -e "\n\t\t${greenColour}[+] -i (IP)${endColour} ${turquoiseColour}10.10.10.10${endColour}"
  echo -e "\n\t\t${greenColour}[+] -p (PORT)${endColour} ${turquoiseColour}80 || 1-100${endColour}"
  echo -e "\n\t\t${greenColour}[+] -h (HELP)${endColour}"
}

function search_ports(){
  tput civis
  local ip=$1
  local port=$2
  if [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    if [[ $2 =~ ^[0-9]{1,5}$ ]]; then
      timeout 1 bash -c "echo > /dev/tcp/$ip/$port && echo -e '${greenColour}[+] Open Port $port${endColour}'" 2>/dev/null
    elif [[ $port == *"-"* ]]; then
      if [[ $(echo $port | sed 's/-/ /g' | awk '{print $1}') =~ ^[0-9]{1,5}$ ]] && [[ $(echo $port | sed 's/-/ /g' | awk '{print $2}') =~ ^[0-9]{1,5}$ ]]; then
        for i in $(seq $(echo $port | sed 's/-/ /g' | awk '{print $1}') $(echo $port | sed 's/-/ /g' | awk '{print $2}')); do
          timeout 1 bash -c "echo > /dev/tcp/$ip/$i && echo -e '${greenColour}[+] Open Port $i${endColour}'" 2>/dev/null &
        done; wait
      else
        echo -e "${redColour}[!] You have to Write a range of ports${endColour}"
      fi
    else
      echo -e "\n\t${redColour}[!] The format of port/s is wrong${endColour}"
    fi
  else
    echo -e "\n\t${redColour}[!] The format of the IP is wrong${endColour}"
  fi
  tput cnorm
}

declare -i counter=0

while getopts "i:p:h" arg; do
  case $arg in
    i) ip_target=$OPTARG; let counter+=2;;
    p) ports_to_scan=$OPTARG; let counter+=2;;
    h);;
  esac
done

if [[ $counter -eq 4 ]]; then
  search_ports $ip_target $ports_to_scan
else
  help_pannel
fi
