#!/bin/bash
#############################################
# Author: darkstardevx@gmail.com
# https://github.com/angryrobot/linux-tools
# Version: 1.0.1
#############################################
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------


EDITOR=nano
PASSWD=/etc/passwd

# Color Chart
RED='\E[97;41m'         # fg= white | bg= red
STD='\033[0;0;39m'
MAGENTA='\E[35;40m'     # fg= magenta | bg= white
CYAN='\E[36;47m'
GREEN='\E[32;47m'
YELLOW='\E[33;40m'
BLUE='\E[34;47m'
WHITE='\E[37;47m'
BLACK='\E[30;47m'

# Column Settings
COLUMNS=12

# Define variables
LSB=/usr/bin/lsb_release

# this function is called when Ctrl-C is sent
function trap_ctrlc ()
{
    # perform cleanup here
    echo "Ctrl-C EXITING MENU"

    # exit shell script with error code 2
    # if omitted, shell script will continue execution
    exit 2
}

# initialise trap to call trap_ctrlc function
# when signal 2 (SIGINT) is received
trap "trap_ctrlc" 2

# ID: Display pause prompt
# $1-> Message (optional)
function pause(){
local message="$@"
[ -z $message ] && message="Press [Enter] key to continue..."
read -p "$message" readEnterKey
}

# ID - Display a menu on screen
show_menus() {
    clear
	echo -e " \e[35m"
	cat << "EOF"
    /\   |  __ \ / ____| |  | | | |    |_   _| \ | | |  | \ \ / / |__   __/ __ \ / __ \| |     / ____|
   /  \  | |__) | |    | |__| | | |      | | |  \| | |  | |\ V /     | | | |  | | |  | | |    | (___
  / /\ \ |  _  /| |    |  __  | | |      | | | . ` | |  | | > <      | | | |  | | |  | | |     \___ \
 / ____ \| | \ \| |____| |  | | | |____ _| |_| |\  | |__| |/ . \     | | | |__| | |__| | |____ ____) |
/_/    \_\_|  \_\\_____|_|  |_| |______|_____|_| \_|\____//_/ \_\    |_|  \____/ \____/|______|_____/
EOF
	echo
	date
	echo -e "\e[1m\e[31mTools Version v.1.4.1 \e[0m" # Tools Version
	echo -e "\e[35m \e[1m"
    echo "+++++++++++++++++++++++++++++++"
    echo -e "\e[1m\e[36mBash Version | $BASH_VERSION"
    now=$(date +"%r")
    echo -e "\e[36m\e[1mCurrent Time | $now"
    echo -e "\e[35m\e[1m+++++++++++++++++++++++++++++++"
	echo -e "\e[35m \e[1m"
    # UNDERLINE
    echo -e "+++++++++++++++++++++++++++++++"
    echo -e "\e[40;38;5;82m A R C H  T O O L S  M E N U \e[0m"
    echo -e "\e[35m\e[1m+++++++++++++++++++++++++++++++"
	echo -e "\e[35m \e[1m"
    echo '  '"1. Clear Cache"
    echo '  '"2. Speedtest"
    echo '  '"3. List Hardware (lshwd)"
    echo '  '"4. Kernel Version"
    echo '  '"5. Free Memory"
    echo '  '"6. System Startup Time"
    echo '  '"7. Package Manager (Pamac Update)"
    echo '  '"8. Package Manager (Yay Update)"
    echo '  '"9. List Packages (Yaourt)"
	echo '  '"10. SSH Config"
	echo '  '"11. NGINX Config"
	echo '  '"12. Apache Config (httpd)"
	echo '  '"13. PHP Config (php.ini)"
	echo '  '"14. PHP-FPM (php.fpm.conf)"
	echo '  '"15. Samba Config (smb.conf)"
	echo '  '"16. Squid Config (squid.conf)"
	echo '  '"17. Privoxy Config"
	echo '  '"18. Display Active Network Connections"
    echo '  '"19. Get WAN IP"
    echo '  '"20. UpdateDB"
    echo '  '"21. GRUB Customizer"
    echo '  '"22. Conky Manager"
    echo '  '"23. Network Info"
    echo '  '"24. OS Info"
    echo '  '"25. Host Info"
    echo '  '"26. Disk Usage Info"
    echo '  '"27. Exit"
    echo '  '
}

# ID - Display header message (write_header)
# $1 - message
function write_header(){
local h="$@"
echo "---------------------------------------------------------------"
echo " ${h}"
echo "---------------------------------------------------------------"
}

# ID - Get Disk Usage Info (disk_info) [26]
function disk_info() {
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
write_header " Disk Usage Info"
if [ "$EXCLUDE_LIST" != "" ] ; then
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}'
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}'
fi
pause
}

# ID - Get info about host such as dns, IP, and hostname (host_info) [25]
function host_info(){
local dnsips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')
write_header " Hostname & DNS Information "
echo "Hostname : $(hostname -s)"
echo "DNS domain : $(hostname -d)"
echo "Fully qualified domain name : $(hostname -f)"
echo "Network address (IP) : $(hostname -i)"
echo "DNS name servers (DNS IP) : ${dnsips}"
pause
}

# ID - Get info about your operating system (os_info) [24]
function os_info(){
write_header " System information "
echo "Operating system : $(uname)"
[ -x $LSB ] && $LSB -a || echo "$LSB command is not insalled (set \$LSB variable)"
#pause "Press [Enter] key to continue..."
pause
}

# ID - Network inferface and routing info (net_info) [23]
function net_info(){
devices=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
write_header " Network Information "
echo "Total network interfaces found : $(wc -w <<<${devices})"

echo "*** IP Addresses Information ***"
ip -4 address show
echo
echo "***********************"
echo "*** Network Routing ***"
echo "***********************"
netstat -nr
echo
echo "**************************************"
echo "*** Interface Traffic Information ***"
echo "**************************************"
netstat -i

pause
}

# ID - Open Conky Manager (conky_man) [22]
function conky_man(){
write_header " Conky Manager "
conky-manager
#pause "Press [Enter] key to continue..."
pause
}

# ID - Grub Customizer (grub_cust) [21]
function grub_cust(){
write_header " Grub Customizer "
grub-customizer
#pause "Press [Enter] key to continue..."
pause
}

# ID - UpdateDB (update_db) [20]
function update_db(){
write_header " Update Database "
sudo updatedb
#pause "Press [Enter] key to continue..."
pause
}

# ID - Get WAN IP (getlan_ip) [19]
function getlan_ip(){
write_header " Get WAN IP "
wanip
#pause "Press [Enter] key to continue..."
pause
}

# ID - Display Active Network Connections (active_net) [18]
function active_net(){
write_header " Display Active Network Connections "
netstat -nat
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit Privoxy Config (priv_conf) [17]
function priv_conf(){
write_header " Edit Privoxy Config "
sudo xed /etc/privoxy/config
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit Squid Config (squid_conf) [16]
function squid_conf(){
write_header " Edit Squid Config "
sudo xed /etc/squid/squid.conf
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit Squid Config (samba_conf) [15]
function samba_conf(){
write_header " Edit Samba Config "
sudo xed /etc/samba/smb.conf
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit PHP-FPM Config (phpfpm_conf) [14]
function phpfpm_conf(){
write_header " Edit PHP-FPM Config "
sudo xed /etc/php/php-fpm.conf
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit PHP ini file (php_ini) [13]
function php_ini(){
write_header " Edit PHP INI "
sudo xed /etc/php/php.ini
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit HTTPD Config (Apache) (httpd_conf) [12]
function httpd_conf(){
write_header " Edit HTTPD Config "
sudo xed /etc/httpd/conf/httpd.conf
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit NGINX Config (nginx_conf) [11]
function nginx_conf(){
write_header " Edit NGINX Config "
sudo xed /etc/nginx/nginx.conf
#pause "Press [Enter] key to continue..."
pause
}

# ID - Edit SSH Config (sshd_conf) [10]
function sshd_conf(){
write_header " Edit SSH Config "
sudo xed /etc/ssh/sshd_config
#pause "Press [Enter] key to continue..."
pause
}

# ID - List Packages in yaourt (yaourt_list) [9]
function yaourt_list(){
write_header " List Packages (Yaourt) "
yaourt -Q
#pause "Press [Enter] key to continue..."
pause
}

# ID - Package Manager (Yay Update) (yay_update) [8]
function yay_update(){
write_header " Package Manager (Yay Update) "
xfce4-terminal -e yay
#pause "Press [Enter] key to continue..."
pause
}

# ID - Package Manager (Pamac Update) (pamac_update) [7]
function pamac_update(){
write_header " Package Manager (Pamac Update) "
pamac update
#pause "Press [Enter] key to continue..."
pause
}

# ID - System Startup Time (sys_start) [6]
function sys_start(){
write_header " System Startup Time "
systemd-analyze
#pause "Press [Enter] key to continue..."
pause
}

# ID - Free Memory (free_mem) [5]
function free_mem(){
write_header " Free Memory "
free -m
#pause "Press [Enter] key to continue..."
pause
}

# ID - Kernel Version (kernel_ver) [4]
function kernel_ver(){
write_header " Kernel Version "
uname -r
#pause "Press [Enter] key to continue..."
pause
}

# ID - List Hardware (lshwd) (lshw_d) [3]
function lshw_d(){
write_header " List Hardware (lshwd) "
lshwd
#pause "Press [Enter] key to continue..."
pause
}

# ID - Speedtest (speed_test) [2]
function speed_test(){
write_header " Speedtest "
speedtest-cli
#pause "Press [Enter] key to continue..."
pause
}

# ID - Clear Cache (clear_cache) [1]
function clear_cache(){
write_header " Clear Cache "
sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
#pause "Press [Enter] key to continue..."
pause
}

# read input from the keyboard and execute command(s)
# menu options
read_options(){
    local c
    read -p "Enter Choice [ 1 - 27] " c
    case $c in
        1) clear_cache ;;
        2) speed_test ;;
        3) lshw_d ;;
        4) kernel_ver ;;
        5) free_mem ;;
        6) sys_start ;;
        7) pamac_update ;;
        8) yay_update ;;
        9) yaourt_list ;;
		10) sshd_conf ;;
		11) nginx_conf ;;
		12) httpd_conf ;;
		13) php_ini ;;
		14) phpfpm_conf ;;
		15) samba_conf ;;
		16) squid_conf ;;
		17) priv_conf ;;
		18) active_net ;;
        19) getlan_ip ;;
        20) update_db ;;
        21) grub_cust ;;
        22) conky_man ;;
        23) net_info ;;
        24) os_info ;;
        25) host_info ;;
        26) disk_info ;;
        27) echo "Exit Complete"; exit 0 ;;
        *) echo -e "${RED} Error... Invalid Choice${STD}" && sleep 2
        pause
    esac
}

# ignore CTRL+C, CTRL+Z and quit singles using the trap
trap '' SIGINT SIGQUIT SIGTSTP

# main logic
while true
do
clear
show_menus # display memu
read_options # wait for user input
done
