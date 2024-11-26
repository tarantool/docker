#!/bin/bash

echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.10.4-gc64-centos7-amd64 tarantool /test.lua
echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.10.4-gc64-amd64 tarantool /test.lua
echo "GC64 yes"
docker run -it --rm -v $(pwd)/test.lua:/test.lua tarantool/tarantool:2.10.4-gc64-ubuntu-amd64 tarantool /test.lua
