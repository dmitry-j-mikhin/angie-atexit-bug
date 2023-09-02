set -ex

docker run -it --rm \
 -v `realpath .`:/tmp/build \
 docker.angie.software/angie:1.2.0-alpine \
 sh -x -c "
apk add --no-cache musl-dbg angie-dbg valgrind
timeout 2 valgrind angie -c /tmp/build/nginx.conf
"
