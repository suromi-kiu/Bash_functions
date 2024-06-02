# here are some small bash functions for file creation

# create a python file add x permits and write shebang
function marpy() {
  if [[ $# -eq 0 ]]; then
    echo "Error: write a name"
  fi

  if [ -n "$1" ]; then
    set_name="${1}.py"
    touch "$set_name" && chmod +x "$set_name"
    echo "#!/usr/bin/env python3" > "$set_name"
  fi
}

# create a cpp file and add x permits
function cppss() {
  if [[ $# -eq 0 ]]; then
    echo "Error: write a name"
  fi

  if [ -n "$1" ]; then
    get_name="${1}.cpp"
    touch "$get_name" && chmod +x "$get_name"
  fi
}

# this function is uses to connect with ssh to overthewire.org
function conover(){

  argument=$1
  bandit=$((argument + 1))
  set_name="bandit${argument}@bandit.labs.overthewire.org"

  if [[ $# -eq 0 ]]; then
    echo "[+] Connecting to https://overthewire.org/wargames/bandit/bandit1.html"
    ssh -o ExitOnForwardFailure=yes "bandit0@bandit.labs.overthewire.org" -p 2220
  fi

  if [[ -n "$1" ]]; then

    if [[ -n "$argument" && $argument -ge 1 ]]; then
      echo "[+] Connecting to https://overthewire.org/wargames/bandit/bandit${bandit}.html"
      ssh -o ExitOnForwardFailure=yes "$set_name" -p 2220
    fi
  fi
}
