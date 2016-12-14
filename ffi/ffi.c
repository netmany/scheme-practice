// file ffi.c

#include <string.h>
#include <stdio.h>

// test ffi arguments passing

#define max(x, y) (((x) > (y)) ? (x) : (y))

int passVal(int srcInt, int* dstInt,
            const char* srcStr, char* dstStr, size_t dstStrLen) {
    *dstInt = srcInt + 1;
    strncpy(dstStr, srcStr, max(dstStrLen, sizeof(srcStr)));
    return 0;
}

struct info {
    char* name;
    char ostype[128];
    long addr[4];
    long cb;
    int age;
};

typedef void (*sig_t)(int);

int getInfo(struct info* p){
    
    printf("getInfo/ p={name=%s, ostype=%s, addr=[%ld,%ld,%ld,%ld], age=%d}\n", 
            p->name, p->ostype,
            p->addr[0], p->addr[1], p->addr[2], p->addr[3],
            p->age);
     
    ((sig_t)p->cb)(12);

    if(strcmp(p->name, "helen") == 0) {
     	p->age += 20;
        p->addr[0] = 11;
        strcpy(p->ostype, "os x");
    } else {
     	p->age = 0;
        p->addr[0] = 22;
        strcpy(p->ostype, "unknown");
    }
    return 0;
}
