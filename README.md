# angie-atexit-bug

This repo demonstrates Angie 1.2.0 bug, when atexit callback function calls getenv function inside module.

Steps for reproduction:
```Shell
$ ./test_angie.sh # build and test module for Angie 1.2.0
...
==3015== Invalid read of size 1
==3015==    at 0x48AA945: strncmp (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==3015==    by 0x401BC0E: getenv (getenv.c:10)
==3015==    by 0x1DBA9E: ngx_http_hello_world_atexit (ngx_http_hello_world_module.c:76)
==3015==    by 0x401C142: __funcs_on_exit (atexit.c:34)
==3015==    by 0x401407C: exit (exit.c:29)
==3015==    by 0x157CEB: ngx_master_process_exit (ngx_process_cycle.c:699)
==3015==    by 0x159720: ngx_single_process_cycle (ngx_process_cycle.c:315)
==3015==    by 0x130183: main (nginx.c:380)
==3015==  Address 0x4e48d68 is 15,272 bytes inside a block of size 16,384 free'd
==3015==    at 0x48A784F: free (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==3015==    by 0x1318AB: ngx_destroy_pool (ngx_palloc.c:90)
==3015==    by 0x157CE1: ngx_master_process_exit (ngx_process_cycle.c:697)
==3015==    by 0x159720: ngx_single_process_cycle (ngx_process_cycle.c:315)
==3015==    by 0x130183: main (nginx.c:380)
==3015==  Block was alloc'd at
==3015==    at 0x48A9C36: posix_memalign (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==3015==    by 0x1542B6: ngx_memalign (ngx_alloc.c:83)
==3015==    by 0x131655: ngx_palloc_block (ngx_palloc.c:186)
==3015==    by 0x131957: ngx_palloc_small (ngx_palloc.c:173)
==3015==    by 0x131957: ngx_palloc (ngx_palloc.c:127)
==3015==    by 0x131A76: ngx_pcalloc (ngx_palloc.c:302)
==3015==    by 0x1C58F9: ngx_http_proxy_create_loc_conf (ngx_http_proxy_module.c:3348)
==3015==    by 0x17E681: ngx_http_core_location (ngx_http_core_module.c:3141)
==3015==    by 0x144A57: ngx_conf_handler (ngx_conf_file.c:463)
==3015==    by 0x144A57: ngx_conf_parse (ngx_conf_file.c:319)
==3015==    by 0x17ECE5: ngx_http_core_server (ngx_http_core_module.c:3047)
==3015==    by 0x144A57: ngx_conf_handler (ngx_conf_file.c:463)
==3015==    by 0x144A57: ngx_conf_parse (ngx_conf_file.c:319)
==3015==    by 0x179BAC: ngx_http_block (ngx_http.c:239)
==3015==    by 0x144A57: ngx_conf_handler (ngx_conf_file.c:463)
==3015==    by 0x144A57: ngx_conf_parse (ngx_conf_file.c:319)
```
Without valgrind we got Segmentation fault:
```
$ timeout 2 objs/angie -p. -e stderr -c /tmp/build/nginx.conf
Segmentation fault (core dumped)
```
Compiled binary with bug for Angie is placed here - https://github.com/dmitry-j-mikhin/angie-atexit-bug/releases/download/v2.0/angie

P.S when compiled with no linux-headers installed there is no such bug:
```Shell
$ ./test_angie_nolh.sh # build test module for Angie 1.2.0
...
==10== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
Nginx 1.25.0 have same behaviour, ./test_nginx.sh - FAIL, ./test_nginx_nolh.sh - PASS

Discussion with @VBart here - https://github.com/webserver-llc/angie/issues/42
