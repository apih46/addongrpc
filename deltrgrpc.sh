#!/bin/bash
# My Telegram : https://t.me/IzhanV
# ==========================================
#########################
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/rare/xray/conf/akuntrgrpc.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/etc/rare/xray/conf/akuntrgrpc.conf" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### " "/etc/rare/xray/conf/akuntrgrpc.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/rare/xray/conf/akuntrgrpc.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "^### $user $exp/,/^},{/d" /etc/rare/xray/conf/akuntrgrpc.conf
sed -i "^### $user $exp/,/^},{/d" /etc/rare/xray/conf/trojangrpc.json
systemctl restart xray.service
service cron restart
clear
echo ""
echo "================================"
echo "  Xray/Trojan Account Deleted  "
echo "================================"
echo "Username  : $user"
echo "Expired   : $exp"
echo "================================"
echo ""
echo "================================"
echo "Script By izhanworks"
echo "================================"
read -p "Press Enter For Back To Trojan Menu/ CTRL+C To Cancel : "
menu-grpc