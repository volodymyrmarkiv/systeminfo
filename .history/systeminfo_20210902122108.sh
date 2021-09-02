#!/usr/bin/env bash

# Version info
version=0.0.1

## RAM variables
totalram=$(free -h | awk 'NR==2 {print $2}')
usedram=$(free -h | awk 'NR==2 {print $3}')
freeram=$(free -h | awk 'NR==2 {print $4}')

## Network variables
private_ip=$(hostname -I | awk '{print $1}')
public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
net_iface_status=$(nmcli device status)

## Disk variables
df_header=$(df -h | sed -u 1q | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$6 }')

# Author and message about version 
echo -e "\033[31mAttention this script is in alpha version\033[0m"
echo -e "\033[32m$0-$version\033[0m by Volodymyr Markiv"

## Show system general info
echo -e "\033[32;47;1m                         GENERAL INFO                         \033[0m"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo
    ## Show OS type
    echo -e "\033[1mOS type:  \033[0m$(uname -o)"
    ## Show distributive name
    echo -e "\033[1mOS:       \033[0m$(grep '^PRETTY_NAME' /etc/os-release | awk -F "\"" '{ print $2 }')"
    ## Show OS version
    echo -e "\033[1mVersion:  \033[0m$(grep -w '^VERSION' /etc/os-release | awk -F "\"" '{ print $2 }')"
    ## Show kernel version
    echo -e "\033[1mKernel:   \033[0m$(uname -r)"
    ## Show hostname
    echo -e "\033[1mHostname: \033[0m$(uname -n)"
    echo
elif [[ $OSTYPE == "darwin"* ]]; then
    echo -e "\033[1mOS: \033[0m$(uname -s)"
fi

## Show RAM information
echo -e "\033[32;47;1m                           RAM INFO                           \033[0m"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo
    echo -e "\033[37;1mTotal: \033[0m\033[37m$totalram\033[0m"
    echo -e "\033[37;1mFree: \033[0m \033[32m$freeram\033[0m"
    echo -e "\033[37;1mUsed: \033[0m \033[31m$usedram\033[0m"
    echo
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo
    echo -e "\033[31;4mMacOS doesn't have free command. So \"RAM info\" is under development.\033[0m"
    echo
fi

## Show disk information
echo -e "\033[32;47;1m                           DISK INFO                          \033[0m"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo
    ## "df" header (first row) 
    echo -e "\033[30;47;1m$df_header\033[0m"
    ## "df" body (w/o header)
    df -h | grep "/dev/[hsv]d[a-z][1-9]" | sort | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$6 }'
    echo
elif [[ "$OSTYPE" == "darwin"* ]]; then
    df -h | sed -u 1q | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$9 }'
    df -h | grep "/dev/disk*" | sort | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$9 }'
else echo "unknown OS"
fi

## Show network information
echo -e "\033[32;47;1m                           NETWORKING                         \033[0m"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo
    echo -e "\033[37;1mPrivate IP: \033[0m\033[0;37m$private_ip\033[0m"
    echo -e "\033[37;1mPublic IP:  \033[0m\033[37m$public_ip\033[0m"
    echo
    echo -e "\033[37;1mNetwork interface status:\033[0m"
    $net_iface_status | sed -u 1q | awk #< make separate header and body
    echo
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo
    echo -e "\033[31;4mMacOS doesn't have free command. So \"RAM info\" is under development.\033[0m"
    echo
fi
