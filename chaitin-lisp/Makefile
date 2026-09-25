# Build Chaitin's lisp.c with the neuromuse extensions on a jailbroken iPhone.
#
# 1. Copy Gregory J. Chaitin's original lisp.c here as lisp.orig.c
# 2. make            (applies neuromuse.patch, then compiles)
# 3. make sign       (optional: ldid with entitlements.plist)

SDK    ?= $(THEOS)/sdks/iPhoneOS16.5.sdk
CC     ?= clang
CFLAGS ?= -O -arch arm64 -isysroot $(SDK)

all: lisp

lisp.c: lisp.orig.c neuromuse.patch
	cp lisp.orig.c lisp.c
	patch -p1 < neuromuse.patch

lisp: lisp.c
	$(CC) $(CFLAGS) -o lisp lisp.c $(LDLIBS)

sign: lisp
	ldid -Sentitlements.plist lisp

clean:
	rm -f lisp lisp.c lisp.c.orig lisp.c.rej

.PHONY: all sign clean
