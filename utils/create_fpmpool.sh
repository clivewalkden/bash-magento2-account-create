#!/usr/bin/env bash

# Create site

# Set ${domain} if null
if [[ -z ${domain} ]]; then
  source  "$( dirname ${BASH_SOURCE[0]} )/set_domain.sh"
fi

# Set ${aliases} if null
if [[ -z ${aliases} ]]; then
  source  "$( dirname ${BASH_SOURCE[0]} )/set_domain_alias.sh"
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

  # Create nginx virtualhost configuration
  sudo sed -e "s/<domain>/${env_domain}/" -e "s/<user>/${env_username}/" -e "s/<phpfpm>/${env_username}/" "${phpfpm_path}/default.conf_" | sudo tee "${phpfpm_path}/${env_domain}.conf" > /dev/null

  echo -e "\n${txt_blue}PHP FPM Pool configuration ${phpfpm_path}/${env_domain}.conf created from ${phpfpm_path}/default.conf_${txt_end}" 

fi
