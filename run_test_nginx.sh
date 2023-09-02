set -ex

docker run -it --rm \
 -v `realpath .`:/tmp/build \
 nginx:1.25.2-alpine3.18-slim \
 sh -x -c "
apk add --no-cache musl-dbg valgrind
timeout 2 valgrind nginx -c /tmp/build/nginx.conf
"
