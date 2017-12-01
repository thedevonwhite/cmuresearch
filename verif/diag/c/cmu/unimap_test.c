#include "libc.h"

int mem[1024];

int main(void) {
  pass();
  for (int i = 0; i < 1024; i++) {
    mem[i] = i;
  }

  for (int j = 0; j < 1024; j++) {
    if (mem[j] != j) {
      fail();
    }
  }
  pass();
}
