LUASRC = $(wildcard src/lua/*.ljs)
LUAOBJ = $(LUASRC:.ljs=.o)
CSRC   = $(wildcard src/c/*.c)
COBJ   = $(CSRC:.c=.o)
PREFIX = /usr/local

LUAJIT_CFLAGS := -include $(CURDIR)/gcc-preinclude.h

all: $(LUAJIT) $(SYSCALL) $(PFLUA)
#       LuaJIT
	@(cd lib/luajit && \
	 $(MAKE) PREFIX=`pwd`/usr/local \
	         CFLAGS="$(LUAJIT_CFLAGS)" && \
	 $(MAKE) DESTDIR=`pwd` install)
	(cd lib/luajit/usr/local/bin; ln -fs ljsjit-2.1.0-beta2 ljsjit)
#       ljsyscall
	@mkdir -p src/syscall/linux
	@cp -p lib/ljsyscall/syscall.ljs   src/
	@cp -p lib/ljsyscall/syscall/*.ljs src/syscall/
	@cp -p  lib/ljsyscall/syscall/linux/*.ljs src/syscall/linux/
	@cp -pr lib/ljsyscall/syscall/linux/x64   src/syscall/linux/
	@cp -pr lib/ljsyscall/syscall/shared      src/syscall/
#       ljndpi
	@mkdir -p src/ndpi
	@cp -p lib/ljndpi/ndpi.ljs src/
	@cp -p lib/ljndpi/ndpi/*.ljs src/ndpi/
	cd src && $(MAKE)

install: all
	install -D src/snabb ${DESTDIR}${PREFIX}/bin/snabb

clean:
	(cd lib/luajit && $(MAKE) clean)
	(cd src; $(MAKE) clean; rm -rf syscall.ljs syscall)

PACKAGE:=snabbswitch
DIST_BINARY:=snabb
BUILDDIR:=$(shell pwd)

dist: DISTDIR:=$(BUILDDIR)/$(PACKAGE)-$(shell git describe --tags)
dist: all
	mkdir "$(DISTDIR)"
	git clone "$(BUILDDIR)" "$(DISTDIR)/snabbswitch"
	rm -rf "$(DISTDIR)/snabbswitch/.git"
	cp "$(BUILDDIR)/src/snabb" "$(DISTDIR)/"
	if test "$(DIST_BINARY)" != "snabb"; then ln -s "snabb" "$(DISTDIR)/$(DIST_BINARY)"; fi
	cd "$(DISTDIR)/.." && tar cJvf "`basename '$(DISTDIR)'`.tar.xz" "`basename '$(DISTDIR)'`"
	rm -rf "$(DISTDIR)"

docker:
	docker build -t snabb .
	@ln -sf ../src/scripts/dock.sh src/snabb
	@echo "Usage: docker run -ti --rm snabb <program> ..."
	@echo "or simply call 'src/snabb <program> ...'"
.SERIAL: all
