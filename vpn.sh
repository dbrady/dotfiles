export VPN_USER=eddy.lopez

# adds VPN password to macOS Keychain
function set-vpn-pw() {
  security add-generic-password -s "AnyConnect" -a "$VPN_USER" -p
}

# removes and adds new VPN password to macOS Keychain
function update-vpn-pw() {
  security -q delete-generic-password -s "AnyConnect" -a "$VPN_USER"
  set-vpn-pw
}

function vpnon() {
 printf "0\n$VPN_USER\n$(security find-generic-password -s "AnyConnect" -a "$VPN_USER" -w)\npush" | /opt/cisco/anyconnect/bin/vpn -s connect vpndev.acimacredit.com
}

alias vpnoff="/opt/cisco/anyconnect/bin/vpn disconnect"

function vpn() {
  if [[ $(ifconfig | grep "mtu 1406" ) ]]
  then
   echo "You're connected to the VPN"
  else
   echo "You're not connected to the VPN"
  fi
}

function vpn_display() {
  if vpn;
    then
      printf " \e[32m[V]"
    else
      printf " \e[31m[V]"
  fi
}

# --------------------------------------------------------------------------------
# And then this goes in PS1 somewhere:
# \$(vpn_display)
