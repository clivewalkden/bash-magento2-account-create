#!/usr/bin/env bash

# Create database

# Set ${username} if null
if [[ -z ${username} ]]; then
  source  "$( dirname ${BASH_SOURCE[0]} )/set_username.sh"
fi

if [[ -n ${username} ]]; then

  dbs=("m2" "wp")

  # Loop through all the databases
  for db in "${dbs[@]}"; do
    # ensure there is no existing value
    unset -v dbpassword
    unset -v dbusername

    random="$(random_string 5)"
    dbusername="${username}_${random}"

    echo -e "\n${txt_white}${bg_black}${db} Database${txt_end}"
    echo -e "Enter a strong database password${txt_end}"
    echo -e "${txt_italic}${txt_muted}(use Lastpass 'Generate Secure Password' or equivalent)${txt_end}\n"

    # loop until validation
    while [[ -z ${dbpassword} ]]; do

      # prompt and set ${dbpassword}
      read -p $'\e[1mDatabase Password\e[0m: ' -r -e -s dbpassword

      # show error if invalid before re-looping
      if [[ -z ${dbpassword} ]]; then
        echo -e "${txt_red}Password is required${txt_end}"
      else

        # Set password for user
        mysql -e "CREATE USER IF NOT EXISTS '${dbusername}'@'10.1.0.%' IDENTIFIED BY '${dbpassword}';"
        mysql -e "CREATE USER IF NOT EXISTS '${dbusername}'@'localhost' IDENTIFIED BY '${dbpassword}';"

        # allow wildcard matching for username as prefix
        prefix="${username}\_%";

        # create production database
        mysql -e "CREATE DATABASE IF NOT EXISTS live_${username}_${db};";

        if [[ ${db} == 'm2' ]]; then
          # Grant Magento permissions
          mysql -e "GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, INDEX, INSERT, LOCK TABLES, REFERENCES, SELECT, SHOW VIEW, TRIGGER, UPDATE ON \`live_${username}_${db}\`.* TO \`${dbusername}\`@\`10.1.0.%\`;"
          mysql -e "GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, INDEX, INSERT, LOCK TABLES, REFERENCES, SELECT, SHOW VIEW, TRIGGER, UPDATE ON \`live_${username}_${db}\`.* TO \`${dbusername}\`@\`localhost\`;"
        else
          # Grant WordPress permissions
          mysql -e "GRANT ALTER, CREATE, DELETE, DROP, INDEX, INSERT, SELECT, UPDATE ON \`live_${username}_${db}\`.* TO \`${dbusername}\`@\`10.1.0.%\`;"
          mysql -e "GRANT ALTER, CREATE, DELETE, DROP, INDEX, INSERT, SELECT, UPDATE ON \`live_${username}_${db}\`.* TO \`${dbusername}\`@\`localhost\`;"
        fi

        # apply changes
        mysql -e "FLUSH PRIVILEGES;"

        echo -e "\n${txt_blue} ${db} created. ${txt_end}"
        echo -e "${txt_italic}${txt_white}Database: ${txt_green}live_${username}_${db}${txt_end}"
        echo -e "${txt_italic}${txt_white}Username: ${txt_green}${dbusername}${txt_end}"
        echo -e "${txt_italic}${txt_white}Password: ${txt_green}${dbpassword}${txt_end}\n"

      fi
    done
  done
fi
