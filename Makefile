######################################
# target
######################################
# do NOT leave space at the end of line
TARGET = gd32f103tbu6

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization for size
ifeq ($(DEBUG), 1)
OPT = -O0
else
OPT = -O1
endif

#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

GD32_CMSIS_DIR = ./Firmware/CMSIS
GD32F10x_CMSIS_DIR = $(GD32_CMSIS_DIR)/GD/GD32F10x/Include
GD32_SPL_DIR = ./Firmware/GD32F10x_standard_peripheral
GD32_SPL_SRC_DIR = $(GD32_SPL_DIR)/Source
GD32_SPL_INC_DIR = $(GD32_SPL_DIR)/Include
GD32_SYSFILE_DIR = $(GD32_CMSIS_DIR)/GD/GD32F10x/Source
USER_SRC_DIR = ./User/Source
USER_INC_DIR = ./User/Include

FREERTOS_INC_DIR = ./freertos/inc
FREERTOS_SRC_DIR = ./freertos/src
FREERTOS_PORT_CORE_DIR = ./freertos/src/portable/GCC/ARM_CM3

# MPU WRAPPERS NOT USED
FREERTOS_COMMON_DIR = ./freertos/src/portable/Common

# define if usb is needed
# USB_INC_DIR


GD32_STARTUP_DIR = $(GD32_CMSIS_DIR)/GD/GD32F10x/Source/GCC


# C includes
C_INCLUDES =  \
-I$(GD32_CMSIS_DIR) \
-I$(GD32F10x_CMSIS_DIR) \
-I$(GD32_SPL_INC_DIR) \
-I$(USER_INC_DIR) \
-I$(FREERTOS_INC_DIR) \
-I$(FREERTOS_PORT_CORE_DIR) \
-I$(FREERTOS_COMMON_DIR) \


######################################
# source
######################################
# C sources
C_SOURCES = \
$(GD32_SYSFILE_DIR)/system_gd32f10x.c \
$(wildcard $(GD32_SPL_SRC_DIR)/*.c) \
$(wildcard $(USER_SRC_DIR)/*.c) \
$(wildcard $(FREERTOS_PORT_CORE_DIR)/*.c) \
$(wildcard $(FREERTOS_SRC_DIR)/*.c)
# $(GD32_SPL_SRC_DIR)/gd32f10x_spi.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_bkp.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_can.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_exti.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_dac.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_wwdgt.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_enet.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_gpio.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_adc.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_fmc.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_dbg.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_timer.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_exmc.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_fwdgt.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_usart.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_misc.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_rcu.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_pmu.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_dma.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_i2c.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_rtc.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_sdio.c \
# $(GD32_SPL_SRC_DIR)/gd32f10x_crc.c \
# $(USER_SRC_DIR)/systick.c \
# $(USER_SRC_DIR)/main.c

ifdef USB_INC_DIR
C_SOURCES += $(USB_SRC)
endif


# ASM sources
ASM_SOURCES =  \
$(GD32_STARTUP_DIR)/startup_gd32f10x_md.S \


GCC_PATH = c:/arm-toolchain/14.3/bin
#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m3

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi


# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DGD32F10X_MD


# AS includes
AS_INCLUDES = 

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -Wextra -Wunused -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependencyGCC_PATH information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = Firmware/Ld/Link.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -u_printf_float -specs=nosys.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections


# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


	


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# program
#######################################
program:
	openocd -f /usr/share/openocd/scripts/interface/cmsis-dap.cfg -f /usr/share/openocd/scripts/target/stm32f1x.cfg -c "program build/$(TARGET).elf verify reset exit"

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
