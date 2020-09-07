FROM alpine:3.12
LABEL maintainer="jacob@tlacuache.us"
WORKDIR /usr/src
COPY APKBUILD /usr/src/APKBUILD

RUN apk update --no-cache && apk add -U --no-cache \
        alpine-sdk sudo cyrus-sasl-dev util-linux-dev autoconf automake db-dev groff \
	libtool unixodbc-dev libsodium-dev shadow openssl-dev
RUN	mkdir -p /var/cache/distfiles && \
	adduser -D builder && \
	usermod -aG abuild builder && \
	chgrp abuild /var/cache/distfiles && \
	chmod g+w /var/cache/distfiles && \
	echo "builder    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/cacheflush.patch && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/fix-manpages.patch && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/openldap-2.4-ppolicy.patch && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/openldap-2.4.11-libldap_r.patch && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/openldap.post-install && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/openldap.post-upgrade && \
	wget https://git.alpinelinux.org/aports/plain/main/openldap/openldap.pre-install && \
	chown -R builder:builder /usr/src && \
	sudo -u builder abuild-keygen -aiqn && \
	sudo -u builder abuild checksum && \
	sudo -u builder abuild
