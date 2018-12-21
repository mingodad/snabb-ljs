TOP_SRCDIR:=..
include $(TOP_SRCDIR)/common.mk

DYNASM = $(ABS_TOP_SRCDIR)/deps/dynasm/dynasm.ljs
CODEGEN = pf/codegen

all:

clean:

preprocess: $(CODEGEN).ljs

$(CODEGEN).ljs: $(CODEGEN).dasl
	ljsjit $(DYNASM) $(CODEGEN).dasl > $(CODEGEN).ljs

check: preprocess
	ljsjit -l pf.types -e 'pf.types.selftest()'
	ljsjit -l pf.utils -e 'pf.utils.selftest()'
	ljsjit -l pf.libpcap -e 'pf.libpcap.selftest()'
	ljsjit -l pf.bpf -e 'pf.bpf.selftest()'
	ljsjit -l pf.parse -e 'pf.parse.selftest()'
	ljsjit -l pf.expand -e 'pf.expand.selftest()'
	ljsjit -l pf.optimize -e 'pf.optimize.selftest()'
	ljsjit -l pf.anf -e 'pf.anf.selftest()'
	ljsjit -l pf.ssa -e 'pf.ssa.selftest()'
	ljsjit -l pf.backend -e 'pf.backend.selftest()'
	ljsjit -l pf.match -e 'pf.match.selftest()'
	ljsjit -l pf.regalloc -e 'pf.regalloc.selftest()'
	ljsjit -l pf.selection -e 'pf.selection.selftest()'
	ljsjit -l pf.codegen -e 'pf.codegen.selftest()'
	ljsjit -l pf -e 'pf.selftest()'
