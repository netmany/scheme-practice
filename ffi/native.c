
#include <string.h>

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
	int age;
};

int getInfo(struct info* p){
     if(strcmp(p->name, "helen") == 0) {
     	p->age = 20;
     } else {
     	p->age = 0;
     }
     return 0;
}
