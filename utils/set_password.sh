#!/usr/bin/env bash

# Set password for username

# Set ${username} if null
if [[ -z ${username} ]]; then

  source  "$( dirname ${BASH_SOURCE[0]} )/set_username.sh"

fi

# continue if required vars are set
if [[ -n ${username} ]]; then

  # ensure there is no existing value
  unset -v password

  echo -e "\n${txt_white}${bg_black}Enter a strong user password${txt_end}
${txt_italic}${txt_muted}(use Lastpass 'Generate Secure Password' or equivalent)${txt_end}\n"

  # loop until validation
  while [[ -z ${password} ]]; do

    # prompt and set ${password}
    read -p $'\e[1mUser Password\e[0m: ' -r -e -s password

    echo -e "\n"

    # show error if invalid before re-looping
    if [[ -z ${password} ]]; then

      echo -e "${txt_red}Password is required${txt_end}"

    else

      # loop through environments
      for envi in "${env[@]}"; do

        # update envars for non production
        if [[ -n ${envi} ]]; then
          # set username for environment
          env_username="${envi}${username}"
        fi

        # Set password for user
        echo ${password} | sudo passwd ${env_username} --stdin

      done

    fi

  done

  # ensure password is unset
  unset -v password

fi
