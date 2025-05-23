PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy

# Compiler flags
CFLAGS = -Wall -Wextra -std=c++17 -ffreestanding -O2 -nostdlib -Isrc -fno-exceptions -fno-rtti
ASFLAGS = -Isrc
LDFLAGS = -nostdlib

# Source files
SOURCE_DIR = src
SOURCES_CPP = $(SOURCE_DIR)/kernel.cpp \
              $(SOURCE_DIR)/uart.cpp \
              $(SOURCE_DIR)/memory.cpp \
              $(SOURCE_DIR)/process.cpp \
              $(SOURCE_DIR)/monitor.cpp

SOURCES_ASM = $(SOURCE_DIR)/vector.s

# Object files
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
OBJECTS_ASM = $(SOURCES_ASM:.s=.o)
OBJECTS = $(OBJECTS_CPP) $(OBJECTS_ASM)

# Output files
TARGET = kernel.bin
LINKER_SCRIPT = $(SOURCE_DIR)/linker.ld

# Path to libgcc
LIBGCC = $(shell $(CC) -print-libgcc-file-name)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) -T $(LINKER_SCRIPT) -o $(TARGET) $(OBJECTS) $(LDFLAGS) $(LIBGCC)

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

run: $(TARGET)
	./run_uart_only.sh
