function marpy() {
  if [[ $# -eq 0 ]]; then
    echo "Error: write a name"
  fi

  if [[ -n "$1" ]]; then
    set_name="${1}.py"
    touch "$set_name" && chmod +x "$set_name"
  fi
}

# create a python file add x permits and write shebang
function marpy() {
  if [[ $# -eq 0 ]]; then
    echo "Error: write a name"
  fi

  if [[ -n "$1" ]]; then
    set_name="${1}.py"
    touch "$set_name" && chmod 754 "$set_name"
    echo "#!/usr/bin/env python3" > "$set_name"
  fi
}

# create a cpp file and add chmod 754
function cppss() {
  if [[ $# -eq 0 ]]; then
    echo "Error: write a name"
  fi

  if [[ -n "$1" ]]; then
    get_name="${1}.cpp"
    touch "$get_name" && chmod 754 "$get_name"
  fi
}

# create a bash file add shebang and chmod 754
function setbsh(){
  if [[ $# -eq 0 ]]; then
    echo "Write a name bro"
    return 1
  fi

  if [[ -n "$1" ]]; then
    get_name="${1}.sh"
    touch "$get_name" && chmod 754 "$get_name"
    echo "#!/usr/bin/env bash" > "$get_name"
  fi
}

# this function is uses to connect with ssh to overthewire.org
function conover() {
  argument=$1
  bandit=$((argument + 1))
  set_name="bandit${argument}@bandit.labs.overthewire.org"

  if [[ $# -eq 0 ]]; then

    echo "[+] Connecting to https://overthewire.org/wargames/bandit/bandit0.html"
    ssh -o ExitOnForwardFailure=yes "bandit0@bandit.labs.overthewire.org" -p 2220

  elif [[ $argument =~ ^(0|[1-9]|[1-2][0-9]|3[0-4])$ ]]; then

    echo "[+] Connecting to https://overthewire.org/wargames/bandit/bandit${bandit}.html"
    ssh -o ExitOnForwardFailure=yes "$set_name" -p 2220

  else

    echo "Usage: conover [level_number]"
    echo "Connects to the specified Bandit level. If no level number is provided, connects to Bandit 0."

  fi
}

function mipp(){
  ip_private=$(ifconfig | awk '/inet/{print $2}' | head -n 1)
  netmsk=$(ifconfig | awk '/inet/{print $4}' | head -n 1)
  broadcs=$(ifconfig | awk '/inet/{print $6}' | head -n 1)

  echo "[IP] Your ip private is: ${ip_private}\n[netmask] Your netmask is: ${netmsk}\n[broadcast] Your broadcast is: ${broadcs}"
}