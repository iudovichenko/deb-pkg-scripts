#!/bin/sh

set -e
set -u

PROJECT=$1
CURRENTDIR=$(pwd)
TEMPDIR=$(mktemp -d -t ${PROJECT}.XXXXX)
BRANCH='debian/newton'

remove_temp_folder() {
    if [ -d "$TEMPDIR" ]; then
        rm --preserve-root -rf "$TEMPDIR"
    fi
}

process_changes() {
    trap remove_temp_folder INT TERM EXIT
    cd $TEMPDIR
    git init -q
    git remote add openstack https://git.openstack.org/openstack/deb-${PROJECT}
    git remote add alioth https://anonscm.debian.org/git/openstack/${PROJECT}
    git fetch -q --all
    git --no-pager log --oneline --decorate openstack/${BRANCH}..alioth/${BRANCH}
    cd $CURRENTDIR
    remove_temp_folder
    trap - INT TERM EXIT
}

process_changes
