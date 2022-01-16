#!/bin/bash
#
# https://www.linkedin.com/pulse/creating-alpine-linux-package-repository-afam-agbodike
# https://www.erianna.com/creating-a-alpine-linux-repository/
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INCOMING="$SCRIPT_DIR/incoming"
REPO_BASE=$( cd "$SCRIPT_DIR/.." && pwd )
REPO_STABLE="$REPO_BASE/stable"

if [ -n "$GPG_PRIVATE_KEY" ]; then
    echo "Importing gpg key"
    gpg2 -v --batch --import <( echo "$GPG_PRIVATE_KEY" | tr "," "\n" )
fi

if [ ! -f ~/.rpmmacros ]; then
    echo "Configuring rpm settings"
    echo "%_gpg_name Reuben Miller <reuben.d.miller@gmail.com>" > ~/.rpmmacros
fi

echo "Signing packages"
rpm --addsign "$INCOMING"/*.rpm

cp "$INCOMING"/*.rpm "$REPO_STABLE"

createrepo "$REPO_STABLE"