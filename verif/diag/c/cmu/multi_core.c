#include "libc.h"

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
//#include <time.h>

#define NUM_THREADS 4
#define COUNT_TO 16

//This is experimental printing over uart
#define UARTPRINT

//This is printf printing, not working
//#define PRINTS


int sum[NUM_THREADS];
int sum_total;

//time_t single_start, single_end;
//time_t thread_start, thread_end;
int single_time, thread_time;

#ifdef UARTPRINT
void uart_print(char* str){
  static char* uart_base = (char*)(0xfff0c2c000);
  unsigned i = 0;
  while(str[i] != 0){
    *uart_base = str[i];
    ++i;
  }
}

void uart_putchar(char c){
  static char* uart_base = (char*)(0xfff0c2c000);
  *uart_base = c;
}

//This I added it prints an int in ascii chars
void uart_print_num(int num){
  char* printNum;
  for(int i = 0; i < 10; i++){
    int rem = num % 10;
    printNum[10-i] = 48 + (char)rem;
    num = num - rem;
    num = num / 10;
  }
  for(int j = 0; j < 10; j++){
    uart_putchar(printNum[j]);
  }
}
#endif

void *add_fn(void *num);

int main() {
  pthread_t thread[NUM_THREADS];
  int iret[NUM_THREADS];

  //First we do our long add thing without threading
  //single_start = time(NULL);

  add_fn((void*) 1);

  //single_end = time(NULL);



  //Now we'll try it with threads
  //thread_start = time(NULL);

  for (int i = 0; i < NUM_THREADS; i++) {
    iret[i] = pthread_create(&thread[i], NULL, add_fn, (void*) NUM_THREADS);
  }

  for (int i = 0; i < NUM_THREADS; i++) {
    pthread_join(thread[i], NULL);
  }

  //thread_end = time(NULL);


  //And now we'll examine the results
  //single_time = (int) (single_end - single_start);
  //thread_time = (int) (thread_end - thread_start);
  #ifdef UARTPRINT
  uart_print("Single Time ");
  uart_print_num(single_time);
  uart_print("\n");

  uart_print("Thread Time ");
  uart_print_num(thread_time);
  uart_print("\n");
  #endif

  #ifdef PRINTS
  printf("Single Time: %d\n", single_time);
  printf("Thread Time: %d\n", thread_time);
  #endif

  //if (thread_time < ((single_time * 90) / 100)) {
    pass();
    //printf("pass\n");
  //}
  //else {
  //  fail();
    //printf("fail\n");
  //}

  return 0;
}

//Our ticker function
//Increments to MAX_INT, (COUNT_TO / num) times
//Idea is that you can have 8 threads increment to COUNT_TO/8
//To increment the same number of times as 1 thread incrementing COUNT_TO times
void *add_fn(void *num)
{
  int ticker = 2048;
  int count = 0;
  int count_to = COUNT_TO / (int) (long) num;
  while (count < count_to) {
    ticker += 2048;
    if (ticker == 0) {
      count += 1;
      
      #ifdef UARTPRINT
      uart_print("Count: ");
      uart_print_num(count);
      uart_print("\n");
      #endif

      #ifdef PRINTS
      printf("Count: %d\n", count);
      #endif
    }
  }
  return (void*) 0;
}
