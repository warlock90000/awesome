#!/bin/zsh

ign=`cat /etc/pacman.conf | grep -e '^Ignore'| awk ' { print $3} '`

function pack_count {
    yaourt -Qqua | grep -v $ign | wc -l
}

function pack_name {
    yaourt -Qua | grep -v $ign
}

"$1"
exit