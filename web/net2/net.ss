(library (net)
    (export htonl htons
            nsocket nbind nlisten naccept
            nread nwrite nopen nclose
            nsleep bzero
            sockaddr_in in_addr)
    (import (chezscheme))
    
    (define clib (load-shared-object "libc.so.6"))

    (define-ftype in_addr
        (struct
          (s_addr unsigned-32)))

    (define-ftype sockaddr_in
        (struct
          (sin_family short)
          (sin_port unsigned-short)
          (sin_addr in_addr)
          (sin_zero (array 8 unsigned-8))))

    (define htonl (foreign-procedure "htonl" (unsigned-32) unsigned-32))
    (define htons (foreign-procedure "htons" (unsigned-16) unsigned-16))
    
    (define nsocket (foreign-procedure "socket" (int int int) int))
    (define nbind (foreign-procedure "bind" (int (* sockaddr_in) unsigned-int) int))
    (define nlisten (foreign-procedure "listen" (int int) int))
    (define naccept (foreign-procedure "accept" (int (* sockaddr_in) u32*) int))
    
    (define nopen (foreign-procedure "open" (string int) int))
    (define nclose (foreign-procedure "close" (int) int))
    (define nread (foreign-procedure "read" (int u8* long) long))
    (define nwrite (foreign-procedure "write" (int u8* long) long))
    
    ; (* sockaddr_in) mapped to void* in C
    (define bzero (foreign-procedure "bzero" ((* sockaddr_in) size_t) void))
    (define nsleep (foreign-procedure "sleep" (unsigned-int) unsigned-int))
    )
