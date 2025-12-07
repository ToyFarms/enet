UNAME_S := $(shell uname -s)

CC := gcc

ifeq ($(WINDOWS),1)
    OS := Windows_NT
endif

ifeq ($(OS),Windows_NT)
    CC := x86_64-w64-mingw32-gcc
    TARGET := enet.dll
    LDFLAGS := -shared
    LIBS := -lwsock32 -lws2_32 -lwinmm

else
    ifeq ($(UNAME_S),Linux)
        TARGET := libenet.so
        LDFLAGS := -shared -fPIC
        LIBS :=
    endif

    ifeq ($(UNAME_S),Darwin)
        TARGET := libenet.dylib
        LDFLAGS := -dynamiclib -fPIC
        LIBS :=
    endif
endif

CFLAGS := -O3 -Wall -fPIC
CPPFLAGS := -Iinclude

SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
