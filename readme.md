## About

Systeminfo is a simple bash script that displays some useful system information as:

- General info like system name and version, kernel version, hostname
- Free and used RAM amount
- Free and used disks space
- Private and public IP adress
- Network status (e.g. list of network interfaces and status of connections)

At the moment script depends on some specific software, so it is better to install it before usage:

- hostname
- dig (dnsutils for Debian, bind-utils for CentOS)
- nnmcli (part of NetworkManager)

Attention, this script is in alpha, but suitable for usage. Development is not active, but I do my best to finish it.

## TODO

1. Add uptime and average load
2. Add cheatsheet with popular commands for various package managers (e.g. ./systeminfo.sh -c yum)
3. Add user monotoring (e.g. who is connected and what is he/she doing)

