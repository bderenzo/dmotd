#!/usr/bin/env bash

#  services:
#    apparmor:   active    cron:  active
#    logrotate:  inactive  lxc:   active
#    network:    active    sshd:  active

columns=2
services=( 'apparmor' 'cron' 'logrotate.timer' 'sshd' 'networking' 'lxc' 'netfilter-persistent' 'lxcfs')
svc_names=('apparmor' 'cron' 'logrotate'       'sshd' 'network'    'lxc' 'iptables'             'lxcfs')

out=''
source ../tools/colors.sh
for i in "${!services[@]}"; do
    svc_status=$(systemctl is-active "${services[${i}]}")
    svc_status=$(c_match "${svc_status}" 'active')
    out+="${svc_names[$i]}:|${svc_status}|"
    (( $(( (i+1) % columns )) == 0 )) && out+='\n'
done
out+='\n'

echo
echo 'services:'
echo -e "${out}" | column -ts '|' | sed -e 's/^/  /'

