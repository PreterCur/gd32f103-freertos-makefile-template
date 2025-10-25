#include <stdio.h>
#include "lwmem.h"
#include "main.h"

#ifdef DEBUG_MEM_EN
#define DEBUG_MEM(...) printf(RTT_CTRL_TEXT_BLUE __VA_ARGS__)
#else
#define DEBUG_MEM(...)
#endif

uint16_t full_req_malloc;

void *malloc(size_t size)
{
  
  full_req_malloc += size;
  void *addr = 0;
  addr = lwmem_malloc(size);
  DEBUG_MEM("Call malloc! Addr: 0x%x size %d Total: %d\r\n", addr, size,full_req_malloc);
  return addr;
}

void free(void * ptrmem)
{
  DEBUG_MEM("Call free! 0x%x\r\n", ptrmem);
  lwmem_free(ptrmem);
}

void *realloc(void *ptrmem, size_t size)
{
  DEBUG_MEM("Call realloc! 0x%x new size %d\r\n", ptrmem,size);
  return lwmem_realloc(ptrmem,size);
}

void *calloc(size_t number, size_t size)
{
  DEBUG_MEM("Call calloc! size block %d num block %d\r\n", number,size);
  return lwmem_calloc(number,size);
}