# Contributor:
# Maintainer:
pkgname=openldap
pkgver=2.4.52
pkgrel=0
pkgdesc="LDAP Server"
url="https://www.openldap.org"
arch="all"
license=custom""
pkgusers="ldap"
pkggroups="ldap"

makedepends="
	$depends_dev
	"

subpackages="$pkgname-doc"

install="$pkgname.pre-install $pkgname.post-install $pkgname.post-upgrade"

source="https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-$pkgver.tgz
        openldap-2.4-ppolicy.patch
        openldap-2.4.11-libldap_r.patch
        cacheflush.patch
        "

prepare() {
        default_prepare
        sed -i '/^STRIP/s,-s,,g' build/top.mk
        libtoolize --force && aclocal && autoconf
}

build() {
        ./configure \
                --build=$CBUILD \
                --host=$CHOST \
                --prefix=/usr \
                --libexecdir=/usr/lib \
                --sysconfdir=/etc \
                --mandir=/usr/share/man \
                --localstatedir=/var/lib/openldap \
                --enable-slapd \
		--enable-crypt \
		--enable-spasswd \
                --enable-modules \
                --enable-dynamic \
		--enable-bdb=mod \
                --enable-dnssrv=mod \
		--enable-hdb=mod \
                --enable-ldap=mod \
                --enable-mdb=mod \
                --enable-meta=mod \
                --enable-monitor=mod \
                --enable-null=mod \
                --enable-passwd=mod \
                --enable-relay=mod \
		--enable-shell-mod \
		--enable-sock=mod \
		--enable-sql=mod \
                --enable-overlays=mod \
                --with-tls=openssl \
                --with-cyrus-sasl \
                --enable-rlookups \
                --with-mp \
                --enable-debug=no \
                --enable-dynacl \
                --enable-aci

        make -j16

        make prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/pbkdf2

        make prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/sha2

        make prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/argon2

        make prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/lastbind

        make prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/lastmod
}

#check() {
        #case "$CARCH" in
        #        arm*|x86) ;;
        #        *) make test ;;
        #esac
#}

package() {
        make DESTDIR="$pkgdir" install

        make DESTDIR="$pkgdir" prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/pbkdf2 install

        make DESTDIR="$pkgdir" prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/sha2 install

        make DESTDIR="$pkgdir" prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/passwd/argon2 install

        make DESTDIR="$pkgdir" prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/lastbind install

        make DESTDIR="$pkgdir" prefix=/usr libexecdir=/usr/lib \
                -C contrib/slapd-modules/lastmod install

        cd "$pkgdir"

        rmdir var/lib/openldap/run


	local path; for path in $(find usr/sbin/ -type l); do
		ln -sf slapd $path
	done

	# Move executable from lib to sbin.
	mv usr/lib/slapd usr/sbin/

	# Move *.default configs to docs.
	mkdir -p usr/share/doc/$pkgname
	mv etc/openldap/*.default usr/share/doc/$pkgname/

	chgrp ldap etc/openldap/slapd.*
	chmod g+r etc/openldap/slapd.*

	install -d -m 700 -o ldap -g ldap \
		var/lib/openldap \
		var/lib/openldap/openldap-data

}
