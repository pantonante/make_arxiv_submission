#!/usr/bin/env bash

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
Color_off='\033[0m'       # Text Reset

# success/info/error/warn {{{
msg() {
  printf '%b\n' "$1" >&2
}

info() {
  msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

success() {
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

warn () {
    msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}
# }}}

need_cmd () {
  if ! hash "$1" &>/dev/null; then
    error "Need '$1' (command not found)"
    exit 1
  fi
}

fetch_repo () {
  info "Trying to clone relevant code"
  git clone https://github.com/pantonante/make_arxiv_submission.git "$1"  
}

main () {
  need_cmd 'git'
  # Create temp folder
  tmp_dir=$(mktemp -d)
  # fetch_repo $tmp_dir
  fetch_repo $tmp_dir
  bash $tmp_dir/generate_arxiv_zip.sh
  success "Done!"
  # Cleanup
  rm -rf $tmp_dir 
}

main $@
