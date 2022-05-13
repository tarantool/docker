TNT_VER=$(shell cat versions/${OS}_${DIST}_${VER})
ROCKS_INSTALLER?='tarantoolctl rocks'
ENABLE_BUNDLED_LIBYAML?='ON'
IMAGE?=tarantool/tarantool
LUAJIT_DISABLE_SYSPROF?=OFF
LUAJIT_ENABLE_GC64?=OFF
NPROC?=4

build:
	[ "${TNT_VER}" != "" ] || (echo "ERROR: TNT_VER not defined" ; exit 1)
	docker build --no-cache --network=host \
		--build-arg ROCKS_INSTALLER=${ROCKS_INSTALLER} \
		--build-arg ENABLE_BUNDLED_LIBYAML=${ENABLE_BUNDLED_LIBYAML} \
		--build-arg TNT_VER=${TNT_VER} \
		--build-arg LUAJIT_DISABLE_SYSPROF=${LUAJIT_DISABLE_SYSPROF} \
		--build-arg LUAJIT_ENABLE_GC64=${LUAJIT_ENABLE_GC64} \
		--build-arg NPROC=${NPROC} \
		--build-arg BASE_IMAGE="${ARCH}${OS}:${DIST}" \
		--progress=plain \
		-t ${IMAGE}:${TAG} -f dockerfiles/${OS}_${DIST} .
	docker run --rm --name tarantool_${TAG} -p ${PORT}:${PORT} -d ${IMAGE}:${TAG}
	docker exec -t tarantool_${TAG} tarantool_is_up
	docker stop tarantool_${TAG}
	if [ -n "${GITLAB_CI}" ] ; then \
		docker push ${IMAGE}:${TAG} ; \
		if [ -n "${TAG_LATEST}" ] ; then \
			docker tag ${IMAGE}:${TAG} ${IMAGE}:${TAG_LATEST} ; \
			docker push ${IMAGE}:${TAG_LATEST} ; \
		fi ; \
	fi
