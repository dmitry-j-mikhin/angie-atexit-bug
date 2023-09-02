# angie-atexit-bug

This repo demonstrates Angie 1.2.0 bug, when atexit callback function calls getenv function inside module.

Steps for reproduction:
```Shell
$ ./build_module_angie.sh # build test module for Angie 1.2.0
...
$ ./run_test_angie.sh
...
==10== Invalid read of size 1
==10==    at 0x48AA945: strncmp (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==10==    by 0x401BC0E: getenv (in /lib/ld-musl-x86_64.so.1)
==10==    by 0x4099FC7: ???
==10==    by 0x1FFF00094F: ???
==10==    by 0x520A1C4: ??? (in /tmp/build/ngx_http_hello_world_module.so)
==10==    by 0x520A1DB: ngx_http_hello_world_atexit (ngx_http_hello_world_module.c:76)
==10==    by 0x1101: ???
==10==    by 0x580047F5: vgMemCheck_handle_free (mc_malloc_wrappers.c:530)
==10==    by 0x401C0ED: at_quick_exit (in /lib/ld-musl-x86_64.so.1)
==10==    by 0x401C142: ??? (in /lib/ld-musl-x86_64.so.1)
==10==    by 0x4E705AF: ???
==10==    by 0x35F: ???
==10==  Address 0x4f6ee08 is 10,504 bytes inside a block of size 16,384 free'd
==10==    at 0x48A784F: free (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==10==    by 0x123343: ngx_destroy_pool (ngx_palloc.c:90)
==10==    by 0x1423D3: ngx_master_process_exit (ngx_process_cycle.c:697)
==10==    by 0x14394D: ngx_single_process_cycle (ngx_process_cycle.c:315)
==10==    by 0x1213DF: main (nginx.c:380)
==10==  Block was alloc'd at
==10==    at 0x48A9C36: posix_memalign (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==10==    by 0x13F1A0: ngx_memalign (ngx_alloc.c:83)
==10==    by 0x123161: ngx_palloc_block (ngx_palloc.c:186)
==10==    by 0x123161: ngx_palloc_small (ngx_palloc.c:173)
==10==    by 0x123D46: ngx_hash_init (ngx_hash.c:403)
==10==    by 0x17A9F0: ngx_http_upstream_hide_headers_hash (ngx_http_upstream.c:7141)
==10==    by 0x1B7A08: ngx_http_scgi_merge_loc_conf (ngx_http_scgi_module.c:1629)
==10==    by 0x15E01A: ngx_http_merge_servers (ngx_http.c:597)
==10==    by 0x15E01A: ngx_http_block (ngx_http.c:270)
==10==    by 0x15E01A: ngx_http_block (ngx_http.c:122)
==10==    by 0x13244E: ngx_conf_handler (ngx_conf_file.c:463)
==10==    by 0x13244E: ngx_conf_parse (ngx_conf_file.c:319)
==10==    by 0x130302: ngx_init_cycle (ngx_cycle.c:292)
==10==    by 0x1211DB: main (nginx.c:292)
```
Without valgrind we got Segmentation fault:
```
$ timeout 2 angie -c /tmp/build/nginx.conf
Segmentation fault (core dumped)
```

P.S on vanilla Nginx 1.25.2 there is no such bug:
```Shell
$ ./build_module_nginx.sh # build test module for Nginx 1.25.2
...
$ ./run_test_nginx.sh
...
==10== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
So looks like it is only Angie regression.

https://github.com/webserver-llc/angie/issues/42
