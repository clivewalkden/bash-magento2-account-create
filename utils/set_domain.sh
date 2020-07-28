#!/usr/bin/env bash

# Set domain name

echo -e "\n${txt_white}${bg_black}Enter the domain without www. (eg. sozodesign.co.uk)${txt_end}\n"

# loop until validation
while [[ -z ${domain} ]]; do

  # prompt and set ${domain}
  read -p $'\e[1mDomain name\e[0m: ' -r -e domain
  # set lowercase
  domain=${domain,,}
  # remove http://
  domain=$(printf '%s' "${domain}" | sed 's/^http:\/\///g')
  # remove https://
  domain=$(printf '%s' "${domain}" | sed 's/^https:\/\///g')
  # remove ://
  domain=$(printf '%s' "${domain}" | sed 's/^:\/\///g')
  # remove //
  domain=$(printf '%s' "${domain}" | sed 's/^\/\///g')
  # remove www.
  domain=$(printf '%s' "${domain}" | sed 's/^www.//g')

  # show error if invalid before re-looping
  if [[ -z ${domain} ]]; then

    echo -e "${txt_red}Domain is required${txt_end}"

  fi

  # make sure it looks like a domain
  if ! [[ ${domain} == *.* ]]; then

    echo -e "${txt_red}Domain format requires a tld${txt_end}"

    unset -v domain

  fi

  # make sure it has no bad characters
  if ! [[ ${domain} =~ ^[A-Za-z0-9.-]+\.[A-Za-z]{2,24}$ ]]; then

    echo -e "${txt_red}Domain format is [a-z0-9.-]+.[a-z]{2,24}${txt_end}"

    unset -v domain

  fi

  # make sure it's not .sozo
  if [[ ${domain} =~ sozo$ ]]; then

    echo -e "${txt_red}Don't use .sozo on the server!${txt_end}"

    unset -v domain

  fi

  # make sure it doesn't exist
  if [[ -f /etc/httpd/sites-available/${domain}.conf ]]; then

    echo -e "${txt_red}Domain ${domain} already exists!${txt_end}"

    unset -v domain

  fi
done

echo -e "${txt_green}Using: ${domain}${txt_end}"
