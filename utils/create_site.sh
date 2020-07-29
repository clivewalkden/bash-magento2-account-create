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
  # set aliases for environment
  env_aliases=${aliases}

  # Make sure custom command(s) don't exist in .bash_profile
  if ! sudo grep -sq ${bash_profile_cmd} "${vhosts_path}/${env_domain}/.bash_profile"; then
    # Add custom command(s) to .bash_profile
    touch "${vhosts_path}/${env_domain}/.bash_profile"
    echo ${bash_profile_cmd} | sudo tee --append "${vhosts_path}/${env_domain}/.bash_profile" > /dev/null
    # Ensure .bash_profile has the right permissions
    sudo chmod 600 "${vhosts_path}/${env_domain}/.bash_profile"
  fi

  # Create backups directory
  sudo mkdir -p "${vhosts_path}/${env_domain}/backups"
  # Create releases directory
  sudo mkdir -p "${vhosts_path}/${env_domain}/deployment/releases"
  # Create repo directory
  sudo mkdir -p "${vhosts_path}/${env_domain}/deployment/repo"
  # Create shared directory
  sudo mkdir -p "${vhosts_path}/${env_domain}/deployment/shared/magento/var/nginx"
  # Create tmp directory
  sudo mkdir -p "${vhosts_path}/${env_domain}/deployment/tmp"
  # Create the nginx log files
  sudo touch "${vhosts_path}/${env_domain}/deployment/shared/magento/var/nginx/access.log"
  sudo touch "${vhosts_path}/${env_domain}/deployment/shared/magento/var/nginx/error.log"

  # Give directories the correct permissions
  sudo find "${vhosts_path}/${env_domain}" -type d -print0 | sudo xargs --no-run-if-empty --null --max-procs=0 chmod 0775
  # Ensure all existing files are owned by new user
  sudo chown -Rf ${env_username}:${env_username} "${vhosts_path}/${env_domain}"

fi
