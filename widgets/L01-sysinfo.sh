#!/usr/bin/env bash

#  system info:
#    system load:   0.01  process:  120
#    cpu usage:     0%    uptime:   30d
#    memory usage:  5%    users:    1
#    temperature:   45°c

mem_warn=50  # %
cpu_warn=20  # %
temp_warn=60 # °c

ps="$(ps -haux | wc -l)"
load="$(cat /proc/loadavg | cut -d' ' -f3)"
users="$(w -h | wc -l)"
up="$(( $(cat /proc/uptime | cut -d'.' -f1) / 3600 / 24 ))"
mem="$(free -b | awk 'FNR == 2 {p=100*$3/$2} END{printf("%0.f",p)}')"
cpunb="$(grep -i '^processor' /proc/cpuinfo | wc -l)"
cpu="$(../tools/cpu.sh)"

source ../tools/colors.sh
#ps=$(c_if $ps '<' '150')
mem=$(c_if  "${mem}"  '<' "${mem_warn}" '%')
load=$(c_if "${load}" '<' "$cpunb")
cpu=$(c_if  "${cpu}"  '<' "${cpu_warn}" '%')

out+="system load:|${load}|process:|${ps}\n"
out+="cpu usage:|${cpu}|uptime:|${up}d\n"
out+="memory usage:|${mem}|users:|${users}\n"

if [[ -f '/sys/class/thermal/thermal_zone0/temp' ]]; then
    temp="$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))"
    temp=$(c_if "${temp}" '<' "${temp_warn}" '°c')
    out+="|temperature:|${temp}"
fi

echo
echo 'system info:'
echo -e "${out}" | column -ts'|' | sed 's,^,  ,'

