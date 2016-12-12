build: native lib test

native:
	mkdir -p out/native
	cc -shared -fPIC -o out/native/libnet.so native/net.c

lib:
	mkdir -p out/lib/os
	echo '(compile-library "os/net.ss" "out/lib/os/net.so")' | scheme -q

test:
	mkdir -p out
	echo '(compile-program "client.ss" "out/client.so")' | scheme -q --libdirs out/lib
	echo '(compile-program "server.ss" "out/server.so")' | scheme -q --libdirs out/lib

clean:
	rm -rf out
