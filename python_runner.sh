#!/bin/bash

install_tools() {
  if [ $(dpkg-query -W -f='${Status}' inotify-tools 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    sudo apt-get install inotify-tools -y
  fi
}

clear_screen() {
  tput reset
}

log_failure() {
  echo -e "\e[31m$1\e[39m"
}

log_success() {
  echo -e "\e[32m$1\e[39m"
}

run_python3_with_file() {
  python3 $1
  result=$?
  if [[ $result != 0 ]]; then
    log_failure "Looks like your wrote some jank Python mate"
  else
    log_success "Congratulations, you haven't written any broken python (in this file)"
  fi
}

watch() {
  clear_screen
  inotifywait -m -r -q --exclude '(.swp)' -e close_write ./ |
  while read path action file; do
    if [[ "$file" == *.py ]]; then
      echo "Python file changed"
      run_python3_with_file $file
    fi
  done
}

install_tools
watch
