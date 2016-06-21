
DEBVERSION = stretch
STRATUS_GIT = '../stratus'

.ONESHELL:
deb:
	rm -rf stratus
	git clone /root/stratus stratus
	cp -r debian stratus
	cd stratus
	mk-build-deps -ir debian/control -t 'apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y'
	debuild -us -uc


docker-deb:
	docker run \
	-v $(shell pwd):/root/stratus-pkg-dist \
	-v $(shell pwd)/$(STRATUS_GIT):/root/stratus \
	-e DEBIAN_FRONTEND=noninteractive \
	debian:$(DEBVERSION) \
		/bin/bash -c ' \
			apt-get update && \
			apt-get install -y make && \
			cd /root/stratus-pkg-dist && \
			make install-buildeb && \
			make deb'

install-buildeb:
	apt-get install -y devscripts
	apt-get install -y git

# vim:set noexpandtab
