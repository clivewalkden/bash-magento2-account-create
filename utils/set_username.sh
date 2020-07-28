#!/usr/bin/env bash

# Set username

echo -e "\n${txt_white}${bg_black}Enter a username for this account${txt_end}
${txt_italic}${txt_muted}should not contain numbers or special characters${txt_end}\n"

# Generate default username from domain if set
if [[ -n ${domain} ]]; then

  # remove .com from end of string
  username=$(printf '%s' "${domain}" | sed 's/.com$//g')
  # remove .net from end of string
  username=$(printf '%s' "${username}" | sed 's/.net$//g')
  # remove .uk from end of string
  username=$(printf '%s' "${username}" | sed 's/.uk$//g')
  # remove .co from end of string
  username=$(printf '%s' "${username}" | sed 's/.co$//g')
  # remove .biz from end of string
  username=$(printf '%s' "${username}" | sed 's/.biz$//g')
  # remove .org from end of string
  username=$(printf '%s' "${username}" | sed 's/.org$//g')
  # remove .ac from end of string
  username=$(printf '%s' "${username}" | sed 's/.ac$//g')
  # remove .gov from end of string
  username=$(printf '%s' "${username}" | sed 's/.gov$//g')
  # remove dashes and dots
  username=${username//[.\-]/}

  # prompt and set ${username}
  read -i ${username} -p $'\e[1mUsername\e[0m: ' -r -e username

fi

# loop until validation
while [[ -z ${username} ]]; do

  # prompt and set ${username}
  read -p $'\e[1mUsername\e[0m: ' -r -e username

  # show error if invalid before re-looping
  if [[ -z ${username} ]]; then

    echo -e "${txt_red}Username is required${txt_end}"

  fi

done
