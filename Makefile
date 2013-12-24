CC=cc
AR=ar rcu
RANLIB=ranlib
USESSL=openssl

CFLAGS=-Wall -g -O2

LIB_A=psynclib.a

ifeq ($(OS),Windows_NT)
    CFLAGS += -DP_OS_WINDOWS
    LIB_A=psynclib.dll
    AR=$(CC) -shared -o
    RANLIB=strip --strip-unneeded
    LDFLAGS=-s
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        CFLAGS += -DP_OS_LINUX
    endif
    ifeq ($(UNAME_S),Darwin)
        CFLAGS += -DP_OS_MACOSX
    endif
endif

OBJ=pcompat.o psynclib.o plibs.o pcallbacks.o pdiff.o pstatus.o papi.o ptimer.o pupload.o pdownload.o pfolder.o psyncer.o ptasks.o psettings.o

ifeq ($(USESSL),openssl)
  OBJ += pssl-openssl.o
  CFLAGS += -DP_SSL_OPENSSL
endif

all: $(LIB_A)

$(LIB_A): $(OBJ)
	$(AR) $@ $(OBJ)
	$(RANLIB) $@

clean:
	rm -f *~ *.o $(LIB_A)

