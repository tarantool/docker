#!/bin/bash

echo "GC64 no"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-nogc64-centos7-amd64 tarantool /test.lua
echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-gc64-centos7-amd64 tarantool /test.lua
echo "GC64 no"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-nogc64-amd64 tarantool /test.lua
echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-gc64-amd64 tarantool /test.lua
echo "GC64 no"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-nogc64-ubuntu20.04-amd64 tarantool /test.lua
echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.11.5-gc64-ubuntu20.04-amd64 tarantool /test.lua
