set -ex

docker run -it --rm \
 -v `realpath .`:/tmp/build \
 alpine:3.18.3 \
 sh -x -c "
apk add --no-cache gcc make musl-dev pcre-dev zlib-dev linux-headers openssl-dev #tools for build
wget https://download.angie.software/files/angie-1.2.0.tar.gz -O - | tar -xvz
cd angie-1.2.0
./configure --prefix=/etc/angie --conf-path=/etc/angie/angie.conf --error-log-path=/var/log/angie/error.log --http-log-path=/var/log/angie/access.log --lock-path=/run/angie/angie.lock --modules-path=/usr/lib/angie/modules --pid-path=/run/angie/angie.pid --sbin-path=/usr/sbin/angie --http-client-body-temp-path=/var/cache/angie/client_temp --http-fastcgi-temp-path=/var/cache/angie/fastcgi_temp --http-proxy-temp-path=/var/cache/angie/proxy_temp --http-scgi-temp-path=/var/cache/angie/scgi_temp --http-uwsgi-temp-path=/var/cache/angie/uwsgi_temp --user=angie --group=angie --with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_v3_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs' --add-dynamic-module=/tmp/build/nginx-hello-world-module --with-cc-opt='-O0 -g3'
make -j8 modules
cp -a -v objs/ngx_http_hello_world_module.so /tmp/build/
"
