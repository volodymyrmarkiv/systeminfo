#!/usr/bin/env bash

# Version info
VERSION=0.3.1

## RAM variables
TOTALRAM=$(free -h | awk 'NR==2 {print $2}')
USEDRAM=$(free -h | awk 'NR==2 {print $3}')
FREERAM=$(free -h | awk 'NR==2 {print $4}')

## Network variables
PRIVATE_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
NMCLI_HEADER=$(nmcli device status | sed -u 1q)

## Disk variables
DF_HEADER=$(df -h | sed -u 1q | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$6 }')

# Author and message about version
echo -e "\033[31mAttention, this is alpha version!\033[0m"

## Script functions:
## Script help option
help_option() {
    echo -e "\033[32m$0, version $VERSION\033[0m by Volodymyr Markiv"
    echo
    echo -e "usage: $0 [-hr]"
    echo
    echo -e "\t-h : display this help message"
    echo -e "\t-r : display missing recommended software for better script functionality"
}

requairments_list_option() {
    echo -e "test"
    echo
    usage
}

## Show system general info
general_info() {
    echo -e "\033[32;47;1m                         GENERAL INFO                         \033[0m"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo
        ## Show OS type
        echo -e "\033[1mOS type:  \033[0m$(uname -o)"
        ## Show distributive name
        echo -e "\033[1mOS:       \033[0m$(grep '^PRETTY_NAME' /etc/os-release | awk -F "\"" '{ print $2 }')"
        ## Distributive name (alternative):
        ## echo -e "\033[1mOS:       \033[0m$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)
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
}

## Show RAM information
ram_info() {
    echo -e "\033[32;47;1m                           RAM INFO                           \033[0m"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo
        echo -e "\033[37;1mTotal: \033[0m\033[37m$TOTALRAM\033[0m"
        echo -e "\033[37;1mFree: \033[0m \033[32m$FREERAM\033[0m"
        echo -e "\033[37;1mUsed: \033[0m \033[31m$USEDRAM\033[0m"
        echo
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo
        echo -e "\033[31;4mMacOS doesn't have free command. So \"RAM info\" is under development.\033[0m"
        echo
    fi
}

## Show disk information
disk_info() {
    echo -e "\033[32;47;1m                           DISK INFO                          \033[0m"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo
        ## "df" header (first row)
        echo -e "\033[30;47;1m$DF_HEADER\033[0m"
        ## "df" body (w/o header)
        df -h | grep '^/dev/[hsv]d[a-z]' | sort | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$6 }'
        echo
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        df -h | sed -u 1q | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$9 }'
        df -h | grep '^/dev/disk' | sort | awk '{ print $1,"\t"$2,"\t"$3,"\t"$4"\t"$5,"\t"$9 }'
    else
        echo "unknown OS"
    fi
}

## Display network information
network_info() {
    echo -e "\033[32;47;1m                           NETWORKING                         \033[0m"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /usr/bin/hostname ]]; then
            echo
            echo -e "\033[37;1mPrivate IP:\033[0m \033[0;37m$PRIVATE_IP\033[0m"
        else
            echo
            echo -e "\033[37;1mPrivate IP:\033[0m \033[31m'hostname' not found, please install it first.\033[0m"
        fi

        if [[ -f /usr/bin/dig ]]; then
            echo -e "\033[37;1mPublic IP:\033[0m  \033[37m$PUBLIC_IP\033[0m"
            echo
        else
            echo -e "\033[37;1mPublic IP:\033[0m \033[31m'dig' not found, please install it first.\033[0m"
            echo
        fi

        if [[ -f /usr/bin/nmcli ]]; then
            echo -e "\033[37;1mNetwork interface status:\033[0m"
            echo -e "\033[30;47;1m$NMCLI_HEADER\033[0m"
            nmcli device status | grep -e 'lo' -e '^enp' -e '^eth'
        else
            echo -e "\033[37;1mNetwork interface status:\033[0m"
            echo -e "\033[31m'nmcli' not found, please install it first.\033[0m"
            #echo -e "Please install \033[37;1mnetwork-manager\033[0m to see \033[37;1mNetwork interface status\033[0m section"
            #echo "In Debian/Ubuntu:"
            #echo "     sudo apt install network-manager"
            # if [ -f /etc/os-release ]; then   # << Resume from here | Detect distro and show message about installation network manager
            #     # freedesktop.org and systemd
            #     . /etc/os-release
            #     OS=$NAME
            #     echo -e "For \033[37;1mNetwork interface status:\033[0m"
            # elif type lsb_release >/dev/null 2>&1; then
            #     # linuxbase.org
            #     OS=$(lsb_release -si)
            #     VER=$(lsb_release -sr)
            # elif [ -f /etc/lsb-release ]; then
            #     # For some versions of Debian/Ubuntu without lsb_release command
            #     . /etc/lsb-release
            #     OS=$DISTRIB_ID
            #     VER=$DISTRIB_RELEASE
            # elif [ -f /etc/debian_version ]; then
            #     # Older Debian/Ubuntu/etc.
            #     OS=Debian
            #     VER=$(cat /etc/debian_version)
            # elif [ -f /etc/SuSe-release ]; then
            #     # Older SuSE/etc.
            #     ...
            # elif [ -f /etc/redhat-release ]; then
            #     # Older Red Hat, CentOS, etc.
            #     ...
            # else
            #     # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
            #     OS=$(uname -s)
            #     VER=$(uname -r)
            # fi

        fi

        echo
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo
        echo -e "\033[31;4mUnder development.\033[0m"
        echo
    fi
}

## Script options
while getopts ":hgrdn" option; do
    case $option in
    h) # display help message
        help_option
        exit 1
        ;;
    g) # display "General info" block
        general_info
        ;;
    r) # display "RAM info" block
        ram_info
        ;;
    d) # display "disk info" block
        disk_info
        ;;
    n) # display "network info" block
        network_info
        ;;
    ?) # invalid option
        echo "Invalid option: $OPTARG"
        exit 1
        ;;
    esac
done

#shift "$((OPTIND-1))"

if [[ $# -eq 0 ]]; then
    general_info
    ram_info
    disk_info
    network_info
fi