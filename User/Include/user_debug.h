#ifndef USER_DEBUG_H
#define USER_DEBUG_H

#define RTT_PRINTF_DEBUG 1
#define GPIO_DEBUG 1

#include "FreeRTOS.h"
#include <stdio.h>
#include <stdarg.h>

#if (SDI_PRINTF_DEBUG == 1)
//    #define SDI_PRINT SDI_PR_OPEN
    #define SDI_DEBUG_BAUDRATE 9600
    #define DEBUG_PRINT printf
#elif (defined(UART_PRINTF_DEBUG))
    #define UART_DEBUG_BAUDRATE 115200
    #define DEBUG_PRINT printf
//    #define ADD_TO_DEBUG_BUF
#elif (RTT_PRINTF_DEBUG == 1)
//#ifdef INC_FREERTOS_H
//    #define DEBUG_PRINT freertos_rtt_printf
//#else
    #define DEBUG_LOG printf
    #define DEBUG_ERR(args...) fprintf(stderr, args)
//#endif
#else
    #define DEBUG_PRINT
    #define ADD_TO_DEBUG_BUF
#endif

#if (GPIO_DEBUG == 1)
    #define DEBUG_PORT        GPIOC
    #define DEBUG_PIN         GPIO_PIN_7

    #define GPIO_DEBUG_TOGGLE() gpio_bit_toggle(GPIOC, GPIO_PIN_11);
#endif

void freertos_rtt_printf(const char *format, ...);



#endif