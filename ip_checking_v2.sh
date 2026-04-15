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
  echo -e "${redColour}[!] Exiting....${endColour}"
  exit 1
}

trap ctrl_c SIGINT

function get_ifp(){
  iface=$(ip route | awk '{print $5}' | head -n 1)
  ip=$(ip a | grep "wlp5s0" | awk '{print $2}' | tail -n 1 | cut -d '/' -f1) 
  echo "$iface - $ip"
}

os_detection=$(cat /etc/os-release | awk '/ID/' | head -n 1 | sed 's/=/ /g' | awk '{print $2}')
function providing_data(){
  echo -e "${blueColour}-------------------- Data --------------------${endColour}"
  results=$(get_ifp)
  echo -e "${greenColour}\n\t[+]${endColour} ${grayColour}OS: ${endColour}${turquoiseColour}$os_detection${endColour}"
  echo -e "${greenColour}\t[+]${endColour} ${grayColour}IFACE: ${endColour}${turquoiseColour}$(echo $results | awk '{print $1}')${endColour}"
  echo -e "${greenColour}\t[+]${endColour} ${grayColour}IPV4: ${endColour}${turquoiseColour}$(echo $results | awk '{print $3}')${endColour}"
}

function warning_ad(){
  clear
  echo -e "${redColour}-------------------- Warning --------------------${endColour}"
  echo -e "${redColour}[!]\n\tYou have to install iproute2, check your linux distribution and search how to install iproute2 to your linux distribution${endColour}"
}

command -v ip &>/dev/null
statuss=$?
if [[ $status -eq 0 ]]; then
  providing_data  
else
  echo -e "${redColour}[!]${endColour} ${grayColour}You do not have iproute2 installed, do you want to install it?${endColour}"
  read -p "[Y/N]" response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    if [[ "$os_detection" == "ubuntu" ]] || [[ "$os_detection" == "debian" ]]; then
      sudo apt install iproute2
      clear; providing_data
    elif [[ "$os_detection" == "fedora" ]] || [[ "$os_detection" == "rhel" ]] || [[ "$os_detection" == "centos" ]]; then
      sudo dnf install iproute2 || sudo dnf install iproute
      if [[ $? -gt 0 ]]; then
        warning_ad
      else
        clear; providing_data
      fi
    elif [[ "$os_detection" == "sles" ]]; then
      sudo zypper install iproute2
      clear; providing_data
    else
      warning_ad
    fi
  else
    ctrl_c
  fi
fi
