#!/usr/bin/env bash

# path to users folders
declare vhosts_path="/var/www/vhosts"
# path to nginx config
nginx_path="/etc/nginx"
# path to php-fpm
phpfpm_path="/etc/php-fpm.d"
# default data for a users .bash_profile
bash_profile_cmd='export HISTTIMEFORMAT="%d/%m/%y %T"'

# to highlight errors eg. echo -e "${txt_red}Required${txt_end}"
txt_end="\e[0;0m"
txt_bold="\e[1;1m"
txt_muted="\e[1;2m"
txt_italic="\e[1;3m"
txt_underline="\e[1;4m"
txt_black="\e[1;30m"
txt_red="\e[1;31m"
txt_green="\e[1;32m"
txt_yellow="\e[1;33m"
txt_blue="\e[1;34m"
txt_magenta="\e[1;35m"
txt_cyan="\e[1;36m"
txt_white="\e[1;37m"
bg_black="\e[1;40m"
bg_red="\e[1;41m"
bg_green="\e[1;42m"
bg_yellow="\e[1;43m"
bg_blue="\e[1;44m"
bg_magenta="\e[1;45m"
bg_cyan="\e[1;46m"
bg_white="\e[1;47m"
bg_black_light="\e[1;100m"
bg_red_light="\e[1;101m"
bg_green_light="\e[1;102m"
bg_yellow_light="\e[1;103m"
bg_blue_light="\e[1;104m"
bg_magenta_light="\e[1;105m"
bg_cyan_light="\e[1;106m"
bg_white_light="\e[1;107m"

DATESTAMP=$(date +%Y%m%d%H%M%S)

# Generate 32 char string based on md5 of now in epoch format
gen_string ()
{
  # date %s # seconds since 1970-01-01 00:00:00 UTC
  # date %N # nanoseconds
  date +%s.%N |
  # md5sum -t # read in text mode
  md5sum -t |
  # awk '{print $1}' # prints the first returned variable
  awk '{print $1}'
}

random_string ()
{
  gen_string | cut -c1-$1
}