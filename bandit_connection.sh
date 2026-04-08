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
  echo -e "${redColour}\n[!] Exiting...${endColour}"
  exit 1
}

trap ctrl_c SIGINT

function checking_user_in_file(){
  local name="$1"
  local password="$2"
  grep -w "$name" bandit_keys.txt &>/dev/null
  code_status=$?
  if [[ $code_status -ne 0 ]]; then
    echo "User: $name -- Password: $password" >> bandit_keys.txt
  fi
}

if [[ -n $1 ]] && [[ -n $2 ]]; then
  if [[ $1 =~ bandit[0-9]{1,2} ]]; then
    testing=$(echo $1 | sed 's/t/ /g' | awk 'NF{print $NF}')
    if [ $testing -lt 34 ]; then
      sshpass -p "$2" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1@bandit.labs.overthewire.org -p 2220 "ls" &>/dev/null
      code_status_ssh=$?
      if [[ $code_status_ssh == 0 ]]; then
        echo -e "${purpleColour}\t\n[+]${endColour} ${greenColour}Starting machine...${endColour}\n"
        if [ -e "bandit_keys.txt" ]; then
          checking_user_in_file "$1" "$2"
        else
          touch bandit_keys.txt
          checking_user_in_file "$1" "$2"
        fi
        if [[ $testing -eq 18 ]]; then
          echo -e "${blueColour}\n[+] You may get the password of the level 19 in some seconds...\n${endColour}"
          sshpass -p "$2" ssh -o LogLevel=QUIET -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1@bandit.labs.overthewire.org -p 2220 "cat readme"
        else
          sshpass -p "$2" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET $1@bandit.labs.overthewire.org -p 2220
        fi
      else
        echo -e "${redColour}\t\n[!] The password is not correct${endColour}"
      fi
    else
      echo -e "${redColour}\t\n[!] The user is not correct${endColour}"
    fi
  else
    echo -e "${redColour}\t\n[!] The user is not correct${endColour}"
  fi
else
  echo -e "${redColour}\t\n[!] You should provide the user and the password :: ${endColour}${greenColour} $0 <user> <password> ${endColour}${redColour}::${endColour}${grayColour} EX= $0 bandit0 bandit0 ${endColour}"
fi
