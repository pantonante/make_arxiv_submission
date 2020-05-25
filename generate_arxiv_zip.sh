#!/usr/bin/env bash

# Settings
ARXIV_FOLDER="arxiv"
ZIP_NAME="arxiv_submission.zip"
MAIN_TEX="main.tex"
MAIN_BBL="main.bbl"
BBL_VER="2.8"

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

check_bbl_version (){
  vers=$(sed -n 2p $1 | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')
  if [[ -z $vers ]]; then
    warn "Could not extract bbl version, arxiv expects vers. 2.8."
  fi
  if [ "$vers" != "2.8" ]; then
    warn "Attention, bbl version is $vers, arxiv expects vers. 2.8."
  fi
}

main () {
  # Change directory to parent path, in order to make this script
  # independent of where we call it from.
  PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
  # Ensure file main.tex and main.bbl exist
  if [[ ! -f "$MAIN_TEX" ]]; then
    error "File $MAIN_TEX  does not exist..."
  fi
  if [[ ! -f "$MAIN_BBL" ]]; then
    error "File $MAIN_BBL does not exist, please compile your LaTeX document"
  fi
  check_bbl_version $MAIN_BBL
  # Create temp folder
  mkdir -p $ARXIV_FOLDER
  # Find biber/biblatex vs bibtex
  is_bibtex=$(grep -v '^ *%' $MAIN_TEX | perl -pe '($_)=/\\(?:bibliography|bibselect)/p')
  is_biber=$(grep -v '^ *%' $MAIN_TEX | perl -pe '($_)=/\\(?:addbibresource)/p')
  if [[ ! -z "$is_bibtex" ]];then
    bib_cmd="--expand-bbl"
  fi
  if [[ ! -z "$is_biber" ]]; then
    bib_cmd="--biber"
  fi
  # Copy only figures required to arxiv folder, remove comments from all sources, expand bib to bbl inside main tex.
  info "Procesing $MAIN_TEX"
  perl $PARENT_PATH/latexpand --copy-figures --empty-comments --show-graphics --verbose $bib_cmd $MAIN_BBL $MAIN_TEX -o main.tex
  # Copy other relevant files
  cp *.bbl $ARXIV_FOLDER/. 2>/dev/null
  cp *.ind $ARXIV_FOLDER/. 2>/dev/null
  cp *.gls $ARXIV_FOLDER/. 2>/dev/null
  cp *.bst $ARXIV_FOLDER/. 2>/dev/null
  cp *.cls $ARXIV_FOLDER/. 2>/dev/null
  # Zip relevant files into arxiv_submission.zip
  # Clean previous zips
  rm -rf ./arxiv_submission.zip
  # Build zip
  info "Zipping all relevant files as: ${ZIP_NAME}"
  zip -r ./${ZIP_NAME} arxiv/*
}

main $@