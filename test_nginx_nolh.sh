set -ex

docker run -it --rm \
 -v `realpath .`:/tmp/build \
 alpine:3.18.3 \
 sh -e -x -c "
apk add --no-cache gcc make musl-dev pcre-dev zlib-dev openssl-dev `#linux-headers` valgrind musl-dbg #tools for build and debug
wget https://nginx.org/download/nginx-1.25.0.tar.gz -O - | tar -xvz
cd nginx-1.25.0
./configure \
 --with-http_v3_module \
 --add-module=/tmp/build/nginx-hello-world-module
make -j`nproc`
timeout 2 valgrind objs/nginx -p. -e stderr -c /tmp/build/nginx.conf
"
