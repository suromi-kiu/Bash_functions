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
  tput cnorm; exit 1
}

function help_pannel(){
  echo -e "\n\t${blueColour}-------------------- Suromi's ICMP Tracer Scanner --------------------${endColour}"
  echo -e "\n\t${yellowColour}[+] Usage: ${endColour} ${purpleColour}Write your IP by doing :: EX: $0 -i 10.10.10.10 || $0 -i 10.10.10.1-254${endColour}"
  echo -e "\n\t\t${greenColour}[+] -i (IP)${endColour} ${turquoiseColour}10.10.10.10${endColour}"
  echo -e "\n\t\t${greenColour}[+] -h (HELP)${endColour}"
}

function icmp_tracer(){
  tput civis
  local ip=$1
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    timeout 1 bash -c "ping -c 1 $ip &>/dev/null && echo -e '${greenColour}[+] The IP $ip is active${endColour}'"
  elif [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}\-[0-9]{1,3}$ ]]; then
    cutted_ip=$(echo $ip | tr '.' '\n' | head -n 3 | tr '\n' '.' | awk '{print $1}')
    for i in $(seq $(echo $ip | tr '.' ' ' | awk 'NF{print $NF}' | cut -d '-' -f1) $(echo $ip | tr '.' ' ' | awk 'NF{print $NF}' | cut -d '-' -f2)); do
      timeout 1 bash -c "ping -c 1 $cutted_ip$i &>/dev/null && echo -e '${greenColour}[+] The IP $cutted_ip$i is active${endColour}'" &
    done; wait
  else
    echo -e "${redColour}[!] Wrong format of IP, good format is :: 10.10.10.10 || 10.10.10.0-254${endColour}"
  fi
  tput cnorm
}

trap ctrl_c SIGINT

declare -i counter=0
while getopts "i:h" arg; do
  case $arg in
    i) ip_target=$OPTARG; let counter+=2;;
    h);;
  esac
done
if [[ $counter -eq 2 ]]; then
  icmp_tracer $ip_target $ports_to_scan
else
  help_pannel
fi
