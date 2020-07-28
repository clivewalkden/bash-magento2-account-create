#!/usr/bin/env bash

# Set Apache Server Aliases

# Set ${domain} if null
if [[ -z ${domain} ]]; then

  source  "$( dirname ${BASH_SOURCE[0]} )/set_domain.sh"

fi

echo -e "\n${txt_white}${bg_black}Enter alias(es) for this domain${txt_end}
Usually www.${domain} plus any sub domains pointing to the public directory
The staging. subdomain is created automatically and is not to be entered here
${txt_italic}${txt_muted}separate with a space${txt_end}\n"

# prompt and set ${aliases}
read -p $'\e[1mAlias(es)\e[0m: ' -i "www.${domain}" -r -e aliases
