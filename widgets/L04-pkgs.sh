#!/usr/bin/env bash

#  packages:
#    3 new packages avalaible...

date=$(date +%Y%m%d)
tmp=/tmp/.motd.pkgs

[[ -r "${tmp}" ]] && source "${tmp}"
if [[ "${lastupdate}" != "${date}" ]]; then
    source ../tools/colors.sh
    apt-get -qq update
    pkgs=$(apt -qq list --upgradable 2>/dev/null | wc -l)
    pkgs=$(c_if_r "${pkgs}" '<' '1' 'no new package' "${pkgs} new packages")
    echo "lastupdate=${date}" >  "${tmp}"
    echo "pkgs='${pkgs}'"     >> "${tmp}"
fi

echo
echo 'packages:'
echo -e "  ${pkgs} avalaible..."

