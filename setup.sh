#!/bin/bash

set -e

yarn=yarnpkg

pushd matrix-js-sdk
$yarn unlink &>/dev/null || true
$yarn link
$yarn install
popd

pushd compound-web
$yarn unlink &>/dev/null || true
$yarn link
$yarn install
popd

pushd matrix-react-sdk
$yarn link matrix-js-sdk
$yarn link @vector-im/compound-web
$yarn unlink &>/dev/null || true
$yarn link
$yarn install
popd

pushd element-web
$yarn link matrix-js-sdk
$yarn link @vector-im/compound-web
$yarn link matrix-react-sdk
$yarn install
popd

pushd element-desktop
$yarn install
# Seshat: compare https://github.com/element-hq/element-desktop/blob/develop/docs/native-node-modules.md#adding-seshat-for-search-in-e2e-encrypted-rooms
$yarn add matrix-seshat
#$yarn add electron-build-env
#$yarn run electron-build-env -- --electron "$electron_version" -- neon build matrix-seshat --release
popd

pushd i18n-helper
$yarn install
popd

# CSS overrides
cp res/css/* matrix-react-sdk/res/css/

# Ensure appropriate .gitignore to avoid unnecessary dirty repos
# when re-running setup. merge_upstream.sh will include this into the
# "Automatic setup commit".
if grep -q res/css/sc- matrix-react-sdk/.gitignore; then
    echo "Skip updating .gitignore, already looks ok"
else
    echo "Updating .gitignore"
    echo -e "\nres/css/sc-*.css" >> matrix-react-sdk/.gitignore
fi
