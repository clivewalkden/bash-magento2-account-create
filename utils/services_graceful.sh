#!/usr/bin/env bash

# Restart all necessary services
if [[ -z ${txt_red} ]]; then
  source "$( dirname ${BASH_SOURCE[0]} )/set_constants.sh"
fi

sudo httpd -t &> /dev/null
if [[ $? -ne 0 ]]; then

  echo -e "\n\n${txt_red}nginx config contains an error, aborting restart.${txt_end}\n"
  sudo nginx -t
  exit 1;

else

  echo -e "\n\n${txt_yellow}Restarting nginx, please wait...${txt_end}\n"
  sudo nginx -s reload
  echo -e "\n\n${txt_green}nginx restarted${txt_end}\n"

fi

sudo php-fpm -t &> /dev/null
if [[ $? -ne 0 ]]; then

  echo -e "\n\n${txt_red}php-fpm config contains an error, aborting restart.${txt_end}\n"
  sudo nginx -t
  exit 1;

else

  echo -e "\n\n${txt_yellow}Restarting php-fpm, please wait...${txt_end}\n"
  sudo systemctl restart php-fpm
  echo -e "\n\n${txt_green}php-fpm restarted${txt_end}\n"

fi

