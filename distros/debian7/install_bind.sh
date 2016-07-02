#---------------------------------------------------------------------
# Function: InstallBind
#    Install bind DNS server
#---------------------------------------------------------------------
InstallBind() {
  echo -n "Installing bind DNS server... ";
  apt-get -y install bind9 dnsutils > /dev/null 2>&1
  echo -e "${green}done! ${NC}\n"
}
