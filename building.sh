# x86

time TAG=2.11.5-gc64-ubuntu20.04-amd64 OS=ubuntu DIST=20.04 VER=2.11.5 NPROC=8 PORT=5200 GC64=ON make -f .github.mk build
time TAG=2.11.5-gc64-centos7-amd64 OS=centos DIST=7 VER=2.11.5 NPROC=8 PORT=5200 GC64=ON make -f .github.mk build
time TAG=2.11.5-gc64-amd64 OS=alpine DIST=3.15 VER=2.11.5 NPROC=8 PORT=5200 LUAJIT_DISABLE_SYSPROF=ON GC64=ON make -f .github.mk build

time TAG=2.11.5-nogc64-ubuntu20.04-amd64 OS=ubuntu DIST=20.04 VER=2.11.5 NPROC=8 PORT=5200 GC64=OFF make -f .github.mk build
time TAG=2.11.5-nogc64-centos7-amd64 OS=centos DIST=7 VER=2.11.5 NPROC=8 PORT=5200 GC64=OFF make -f .github.mk build
time TAG=2.11.5-nogc64-amd64 OS=alpine DIST=3.15 VER=2.11.5 NPROC=8 PORT=5200 LUAJIT_DISABLE_SYSPROF=ON GC64=OFF make -f .github.mk build

# arm
time TAG=2.11.5-gc64-ubuntu20.04-aarch64 OS=ubuntu DIST=20.04 VER=2.11.5 NPROC=8 PORT=5200 GC64=OFF make -f .github.mk build
time TAG=2.11.5-gc64-centos7-aarch64 OS=centos DIST=7 VER=2.11.5 NPROC=8 PORT=5200 GC64=OFF make -f .github.mk build
time TAG=2.11.5-gc64-aarch64 OS=alpine DIST=3.15 VER=2.11.5 NPROC=8 PORT=5200 LUAJIT_DISABLE_SYSPROF=ON GC64=ON make -f .github.mk build


# x86
docker push tarantool/tarantool:2.11.5-gc64-centos7-amd64
docker push tarantool/tarantool:2.11.5-gc64-amd64
docker push tarantool/tarantool:2.11.5-gc64-ubuntu20.04-amd64

docker push tarantool/tarantool:2.11.5-nogc64-centos7-amd64
docker push tarantool/tarantool:2.11.5-nogc64-amd64
docker push tarantool/tarantool:2.11.5-nogc64-ubuntu20.04-amd64

# arm
docker push tarantool/tarantool:2.11.5-gc64-centos7-aarch64
docker push tarantool/tarantool:2.11.5-gc64-aarch64
docker push tarantool/tarantool:2.11.5-gc64-ubuntu20.04-aarch64

# Manifests for alpine gc64
docker manifest rm tarantool/tarantool:2
docker manifest rm tarantool/tarantool:2.11
docker manifest rm tarantool/tarantool:2.11.5

docker manifest create tarantool/tarantool:2 tarantool/tarantool:2.11.5-gc64-aarch64 tarantool/tarantool:2.11.5-gc64-amd64
docker manifest create tarantool/tarantool:2.11 tarantool/tarantool:2.11.5-gc64-aarch64 tarantool/tarantool:2.11.5-gc64-amd64
docker manifest create tarantool/tarantool:2.11.5 tarantool/tarantool:2.11.5-gc64-aarch64 tarantool/tarantool:2.11.5-gc64-amd64

docker manifest push tarantool/tarantool:2
docker manifest push tarantool/tarantool:2.11
docker manifest push tarantool/tarantool:2.11.5

# Alpine nogc64
docker manifest rm tarantool/tarantool:2-nogc64
docker manifest rm tarantool/tarantool:2.11-nogc64
docker manifest rm tarantool/tarantool:2.11.5-nogc64

docker manifest create tarantool/tarantool:2-nogc64 tarantool/tarantool:2.11.5-gc64-amd64
docker manifest create tarantool/tarantool:2.11-nogc64 tarantool/tarantool:2.11.5-gc64-amd64
docker manifest create tarantool/tarantool:2.11.5-nogc64 tarantool/tarantool:2.11.5-gc64-amd64

docker manifest push tarantool/tarantool:2-nogc64
docker manifest push tarantool/tarantool:2.11-nogc64
docker manifest push tarantool/tarantool:2.11.5-nogc64


#ubuntu20.04 gc64
docker manifest rm tarantool/tarantool:2-ubuntu20.04
docker manifest rm tarantool/tarantool:2.11-ubuntu20.04
docker manifest rm tarantool/tarantool:2.11.5-ubuntu20.04

docker manifest create tarantool/tarantool:2-ubuntu20.04 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-aarch64 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-amd64
docker manifest create tarantool/tarantool:2.11-ubuntu20.04 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-aarch64 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-amd64
docker manifest create tarantool/tarantool:2.11.5-ubuntu20.04 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-aarch64 tarantool/tarantool:2.11.5-gc64-ubuntu20.04-amd64

docker manifest push tarantool/tarantool:2-ubuntu20.04
docker manifest push tarantool/tarantool:2.11-ubuntu20.04
docker manifest push tarantool/tarantool:2.11.5-ubuntu20.04

#ubuntu20.04 nogc64
docker manifest rm tarantool/tarantool:2-nogc64-ubuntu20.04
docker manifest rm tarantool/tarantool:2.11-nogc64-ubuntu20.04
docker manifest rm tarantool/tarantool:2.11.5-nogc64-ubuntu20.04

docker manifest create tarantool/tarantool:2-ubuntu20.04-nogc64 tarantool/tarantool:2.11.5-nogc64-ubuntu20.04-amd64
docker manifest create tarantool/tarantool:2.11-ubuntu20.04-nogc64 tarantool/tarantool:2.11.5-nogc64-ubuntu20.04-amd64
docker manifest create tarantool/tarantool:2.11.5-ubuntu20.04-nogc64 tarantool/tarantool:2.11.5-nogc64-ubuntu20.04-amd64

docker manifest push tarantool/tarantool:2-nogc64-ubuntu20.04
docker manifest push tarantool/tarantool:2.11-nogc64-ubuntu20.04
docker manifest push tarantool/tarantool:2.11.5-nogc64-ubuntu20.04

#centos7 gc64
docker manifest rm tarantool/tarantool:2-centos7
docker manifest rm tarantool/tarantool:2.11-centos7
docker manifest rm tarantool/tarantool:2.11.5-centos7

docker manifest create tarantool/tarantool:2-centos7 tarantool/tarantool:2.11.5-gc64-centos7-aarch64 tarantool/tarantool:2.11.5-gc64-centos7-amd64
docker manifest create tarantool/tarantool:2.11-centos7 tarantool/tarantool:2.11.5-gc64-centos7-aarch64 tarantool/tarantool:2.11.5-gc64-centos7-amd64
docker manifest create tarantool/tarantool:2.11.5-centos7 tarantool/tarantool:2.11.5-gc64-centos7-aarch64 tarantool/tarantool:2.11.5-gc64-centos7-amd64

docker manifest push tarantool/tarantool:2-centos7
docker manifest push tarantool/tarantool:2.11-centos7
docker manifest push tarantool/tarantool:2.11.5-centos7


#centos7 nogc64
docker manifest rm tarantool/tarantool:2-nogc64-centos7
docker manifest rm tarantool/tarantool:2.11-nogc64-centos7
docker manifest rm tarantool/tarantool:2.11.5-nogc64-centos7

docker manifest create tarantool/tarantool:2-nogc64-centos7 tarantool/tarantool:2.11.5-nogc64-centos7-amd64
docker manifest create tarantool/tarantool:2.11-nogc64-centos7 tarantool/tarantool:2.11.5-nogc64-centos7-amd64
docker manifest create tarantool/tarantool:2.11.5-nogc64-centos7 tarantool/tarantool:2.11.5-nogc64-centos7-amd64

docker manifest push tarantool/tarantool:2-nogc64-centos7
docker manifest push tarantool/tarantool:2.11-nogc64-centos7
docker manifest push tarantool/tarantool:2.11.5-nogc64-centos7
