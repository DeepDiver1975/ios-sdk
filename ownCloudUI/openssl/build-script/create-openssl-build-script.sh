#!/bin/bash
echo "Downloading script.."
/usr/bin/curl "https://gist.githubusercontent.com/steipete/a6a9a5085d2caa166407/raw/5dae044c6fb64527905fbb7b4b128e91c6fd21f3/openssl-build.sh" >openssl-build.sh

echo "Applying patches.."
/usr/bin/patch -p0 openssl-build.sh openssl-build.patch

echo "Verifiying integrity.."
echo "28d5748105ab30beebf8f8741ec4cce5d3f4334c  openssl-build.sh" | shasum -c -
chmod u+x openssl-build.sh
