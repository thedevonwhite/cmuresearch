#define USE_STACK
#include "c/template_mt.s"
MIDAS_CC FILE=cmu/multi_core.c ARGS=-pthread -O2 -S
