#!/bin/bash

set -xeuo pipefail

rm -vf fonts-jetbrains-mono_*.deb

gitinfo=$(git describe --long --tags --dirty=+)
gitinfo=${gitinfo#v}
version=${gitinfo%%-*}
release=${gitinfo#*-}

install -m 644 web/woff2/jetbrains-mono.css ~www-data/html/software/jetbrains-mono-web/
install -m 644 web/woff2/*.woff2 ~www-data/html/software/jetbrains-mono-web/

fakeroot checkinstall \
	--type=debian \
	--fstrans=yes \
	--install=no \
	--pkgname=fonts-jetbrains-mono \
	--pkgversion="$version" \
	--arch=all \
	--pkgrelease="$release" \
	--pkgsource=https://github.com/fastcat/JetBrainsMono \
	--pkgaltsource=https://github.com/JetBrains/JetBrainsMono \
	--pkglicense=Apache-2.0 \
	--pkggroup=fonts \
	--maintainer="'Matthew Gabeler-Lee <chetah@fastcat.org>'" \
	--reset-uids=yes \
	--backup=no \
	./install.sh \
	</dev/null

debfile="fonts-jetbrains-mono_${version}-${release}_all.deb"
test -f "$debfile"

adddebs "$debfile"
sudo apt install ./"$debfile"
