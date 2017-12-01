#include "libc.h"

static int array [1000];

int main() {
    long i __attribute__((aligned(64)));
    int x __attribute__((aligned(64)));
    x = 0;
    for (i = 0; i < 1000; i++) {
	x += 1;
        array[i] = i;
    }
    //for (i = 0; i < 1000; i++) {
    //    if (array[i] != i) {
    //        fail();
    //    }
    //}
    if (x == 1000)
      pass();
    else
      fail();
    fail();
}

