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