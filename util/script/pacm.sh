#!/bin/zsh

ign=`cat /etc/pacman.conf | grep -e '^Ignore'| awk ' { print $3} '`

function pack_count {
    yaourt -Qqua | grep -v $ign | wc -l
}

function pack_name {
    yaourt -Qua | grep -v $ign
}

if [ "$?" = 0 ]; then
    if [ "$1" = "pack_count" ]; then
        pack_count;
    elif [ "$1" = "pack_name" ]; then
        pack_name;
    else
        echo "ERROR1";
    fi;
else
    echo "ERROR"
fi
exit