#!/usr/bin/env bash

if [[ -z ${username} ]]; then

  source  "$( dirname ${BASH_SOURCE[0]} )/set_username.sh"

fi

if [[ -z ${domain} ]]; then

  source  "$( dirname ${BASH_SOURCE[0]} )/set_domain.sh"

fi

# continue if required vars are set
if [[ -n ${username} ]] && [[ -n ${domain} ]]; then

  # set username for environment
  env_username="${username}"
  # set domain for environment
  env_domain="${domain}"

  # loop through environments
  for envi in "${env[@]}"; do

    # update envars for non production
    if [[ -n ${envi} ]]; then

      # set username for environment
      env_username="${envi}${username}"
      # set domain for environment
      env_domain="${envi}.${domain}"

    fi

    # sanity check for removing deployer from group
    if id -nG "deployer" | grep -qw "${env_username}"; then

      # remove deployer from the user group
      gpasswd -d deployer ${env_username}

    fi

    # sanity check for removing nginx from group
    if id -nG "nginx" | grep -qw "${env_username}"; then

      # remove apache from the user group
      gpasswd -d nginx ${env_username}

    fi

    # sanity check for removing the user
    if [[ -n $(getent passwd ${env_username}) ]]; then

      # remove user and home directory
      userdel -r ${env_username}

    fi

    # sanity check for removing the group
    if [[ -n $(getent group ${env_username}) ]]; then

      echo -e "${txt_red}"
      # remove user group
      groupdel ${env_username}
      echo -e "${txt_end}"

    fi

    echo -e "${txt_red}"
    
    # remove domains conf file
    echo "Removing ${nginx_path}/conf.d/${env_domain}.conf"
    sudo rm -rf "${nginx_path}/conf.d/${env_domain}.conf"
    # remove domains conf symlink
    echo "Removing ${phpfpm_path}/conf.d/${env_domain}.conf"
    sudo rm -rf "${phpfpm_path}/conf.d/${env_domain}.conf"

    echo -e "${txt_end}"

  done

  # remove user from database - no tables are remove by this process
  mysql -e "DROP USER '${username}'"

  # apply changes
  mysql -e "FLUSH PRIVILEGES;"

  echo -e "\n${txt_yellow}Databases belonging to ${username} will need to be manually deleted:${txt_end}"

fi
