#!/usr/bin/env bash

# Create user via adduser and set password & groups via usermod

# Set ${domain} if null
if [[ -z ${domain} ]]; then
  source  "$( dirname ${BASH_SOURCE[0]} )/set_domain.sh"
fi

# Set ${username} if null
if [[ -z ${username} ]]; then
  source  "$( dirname ${BASH_SOURCE[0]} )/set_username.sh"
fi

# continue if required vars are set
if [[ -n ${domain} ]] && [[ -n ${username} ]]; then

  # set username for environment
  env_username=${username}
  # set domain for environment
  env_domain=${domain}

  # create user with default group sozo and create home directory
  sudo adduser ${env_username} -G sozo -d "${vhosts_path}/${env_domain}" &> /dev/null
  # Lock password
  sudo usermod -L ${env_username}
  # Add deployer user to the new users group
  sudo usermod -a -G ${env_username} deployer
  # Add apache user to the new users group
  sudo usermod -a -G ${env_username} nginx
  # Add apache user to the new users group
  sudo usermod -a -G nginx ${env_username}

  echo -e "\n${txt_blue}User ${env_username} created with a locked password on ${env_domain}${txt_end}"

  echo -e "\nSSH access available only with a valid key pair
${txt_italic}${txt_muted}(must be unlocked by root to enable password authentication)${txt_end}\n"

fi
