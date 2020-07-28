#!/usr/bin/env bash

# Restart all necessary services
if [[ -z ${txt_red} ]]; then
  source "$( dirname ${BASH_SOURCE[0]} )/set_constants.sh"
fi

# Check for the existance of pcs (Cluster)
if ! command -v pcs &> /dev/null; then

  # Restart php-fpm
  sudo php-fpm -t &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "\n\n${txt_red}php-fpm config contains an error, aborting restart.${txt_end}\n"
    sudo php-fpm -t
    exit 1;
  else
    echo -e "\n\n${txt_yellow}Restarting php-fpm, please wait...${txt_end}\n"
    sudo systemctl restart php-fpm
    echo -e "\n\n${txt_green}php-fpm restarted${txt_end}\n"
  fi
else
  # Restart pcs controlled php-fpm
  sudo php-fpm -t &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "\n\n${txt_red}php-fpm config contains an error, aborting restart.${txt_end}\n"
    sudo php-fpm -t
    exit 1;
  else
    echo -e "\n\n${txt_yellow}Restarting php-fpm, please wait...${txt_end}\n"
    sudo pcs resource restart r_web_php-fpm
    echo -e "\n\n${txt_green}php-fpm restarted${txt_end}\n"
  fi 
fi

# Restart nginx
sudo nginx -t &> /dev/null
if [[ $? -ne 0 ]]; then
  echo -e "\n\n${txt_red}nginx config contains an error, aborting restart.${txt_end}\n"
  sudo nginx -t
  exit 1;
else
  echo -e "\n\n${txt_yellow}Restarting nginx, please wait...${txt_end}\n"
  sudo nginx -s reload
  echo -e "\n\n${txt_green}nginx restarted${txt_end}\n"
fi