# Contributor: Natanael Copa <ncopa@alpinelinux.org>
# Maintainer: Natanael Copa <ncopa@alpinelinux.org>
pkgname=openbox
pkgver=3.6.1
pkgrel=3
pkgdesc="A highly configurable and standards-compliant X11 window manager"
url="http://openbox.org"
arch="all"
license="GPL-2.0-or-later"
depends_dev="
	libxcursor-dev
	libxinerama-dev
	libxrandr-dev
	startup-notification-dev
	"
makedepends="$depends_dev
	autoconf
	automake
	gettext-dev
	imlib2-dev
	librsvg-dev
	libtool
	libxml2-dev
	pango-dev
	"
subpackages="$pkgname-dev $pkgname-doc $pkgname-libs $pkgname-gnome
	$pkgname-kde $pkgname-lang"

# openbox_3.6.1.orig.tar.gz
source="openbox-$pkgver.tar.gz
	python3.patch
	"

prepare() {
	default_prepare
	patch -p2 --directory="${srcdir}/$pkgname-$pkgver" --forward --input="${srcdir}/../openbox.title.patch"
	autoreconf -fi
}

build() {
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--sysconfdir=/etc \
		--disable-static
	make
}

check() {
	make check
}

package() {
	make -j1 DESTDIR="$pkgdir" install
}

libs() {
	pkgdesc="Shared libraries for openbox"
	mkdir -p "$subpkgdir"/usr/lib
	mv "$pkgdir"/usr/lib/lib*.so.* "$subpkgdir"/usr/lib/
}

gnome() {
	pkgdesc="GNOME integration for openbox"
	mkdir -p "$subpkgdir"/usr/bin \
		"$subpkgdir"/usr/share/xsessions

	mv "$pkgdir"/usr/bin/*gnome* \
		"$pkgdir"/usr/bin/gdm-control \
		"$subpkgdir"/usr/bin/
	mv "$pkgdir"/usr/share/*gnome* \
		"$subpkgdir"/usr/share/
	mv "$pkgdir"/usr/share/xsessions/*gnome* \
		"$subpkgdir"/usr/share/xsessions/
}

kde() {
	pkgdesc="KDE integration for openbox"
	mkdir -p "$subpkgdir"/usr/bin \
		"$subpkgdir"/usr/share/xsessions

	mv "$pkgdir"/usr/bin/*kde* \
		"$subpkgdir"/usr/bin/
	mv "$pkgdir"/usr/share/xsessions/*kde* \
		"$subpkgdir"/usr/share/xsessions/
}

sha512sums="
5e6f4a214005bea8b26bc8959fe5bb67356a387ddd317e014f43cb5b5bf263ec617a5973e2982eb76a08dc7d3ca5ec9e72e64c9b5efd751001a8999b420b1ad0  openbox-3.6.1.tar.gz
bd9314998e8239fefd4449928d3bac1a9cc94542fd8c2e76499fbb56e4770af4967e1dfcbb6425acffd22f4d4f443faf2caadef913a13ed42a154ce6ac963e53  python3.patch
"
