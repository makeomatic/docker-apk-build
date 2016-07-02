BUILD_ID ?= ${USER}
# HTTP_PROXY := $(shell ifconfig en0 | grep inet | grep -v inet6 | awk '{print $$2}')

.PHONY: builder
builder:
	# docker build -t apk_builder:${BUILD_ID} --build-arg HTTP_PROXY=http://${HTTP_PROXY}:8080 builder/
	docker build -t apk_builder:${BUILD_ID} builder/

target:
	mkdir -p target
aports:
	git clone git://dev.alpinelinux.org/aports

.PHONY: aports_upadte
aports_update: aports
	GIT_DIR=aports/.git git fetch origin -p
	GIT_DIR=aports/.git git pull origin master

user.abuild:
	mkdir -p user.abuild

build: builder target aports
	docker run -ti \
		-v ${PWD}/user.abuild/:/home/packager/.abuild \
		-v ${PWD}/aports:/work \
		-v ${PWD}/target:/target \
		-v ${HOME}/.gitconfig/:/home/packager/.gitconfig \
		apk_builder:${BUILD_ID} \
		sh

.PHONY: tester
tester:
	docker build -t apk_testing:${BUILD_ID} --build-arg HTTP_PROXY=http://${HTTP_PROXY}:8080 testing/

test: tester target
	docker run -ti \
		-e HTTP_PROXY=http://${HTTP_PROXY}:8080 \
		-v ${PWD}/target:/repo \
		-v ${PWD}/user.abuild/:/home/abuild/ \
		--privileged \
		apk_testing:${BUILD_ID}
