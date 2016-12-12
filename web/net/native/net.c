#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>

int net_connect(char* ip, int port) {
    int s = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in server;
    bzero((char *) &server, sizeof(server));
    server.sin_family = AF_INET;
    server.sin_port = htons(port);    
    struct hostent *host = gethostbyname(ip);
    bcopy(host->h_addr, (char *)&(server.sin_addr.s_addr), host->h_length);
    
    if(connect(s, (struct sockaddr *) &server, sizeof(server)) == 0) {
        return s;
    } else {
        return -1;
    }
}

void net_close(int s) {
    close(s);
}

int net_read(int s, char* buf, int len) {
    return read(s, buf, len);
}

int net_write(int s, char* buf, int len) {
    return write(s, buf, len);
}

int net_listen(int port) {
    int s = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in server;
    
    int reuse = 1;
    if(setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (const char*)&reuse, sizeof(reuse)) < 0) {
        return -2;
    }

    bzero((char *) &server, sizeof(server));
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    server.sin_addr.s_addr = INADDR_ANY;
    
    if(bind(s, (struct sockaddr *)&server, sizeof(server)) == 0) {
        listen(s, 5);
        return s;
    } else {
        return -1;
    }
}

int net_accept(int s) {
    struct sockaddr_in client;
    int size = sizeof(client);
    return accept(s, (struct sockaddr *) &client, &size);
}


