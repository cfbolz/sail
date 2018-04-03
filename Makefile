ARCHS += power
ARCHS += arm
ARCHS += risc-v
# ARCHS += mips
# ARCHS += cheri
ARCHS += x86

all: sail interpreter
.PHONY: all

sail:
	$(MAKE) -C src
	ln -f -s src/sail.native sail
.PHONY: sail

language:
	$(MAKE) -C language
.PHONY: language

interpreter:
	$(MAKE) -C src interpreter
.PHONY: interpreter

archs:
	for arch in $(ARCHS); do\
	  $(MAKE) -C "$$arch" || exit;\
	done
.PHONY: archs

isabelle-lib:
	$(MAKE) -C isabelle-lib
.PHONY: isabelle-lib

apply_header:
	$(MAKE) clean
	headache -c etc/headache_config -h etc/mips_header `ls mips/*.sail`
	headache -c etc/headache_config -h etc/mips_header `ls cheri/*.sail`
	headache -c etc/headache_config -h src/LICENCE `ls src/Makefile*`
	headache -c etc/headache_config -h src/LICENCE `ls src/*.ml*`
	headache -c etc/headache_config -h src/LICENCE `ls src/lem_interp/*.ml`
	headache -c etc/headache_config -h src/LICENCE `ls src/lem_interp/*.lem`
	$(MAKE) -C arm apply_header
.PHONY: apply_header

clean:
	for subdir in src arm ; do\
	  $(MAKE) -C "$$subdir" clean;\
	done
	-rm sail
.PHONY: clean

clean_archs:
	for arch in $(ARCHS); do\
	  $(MAKE) -C "$$arch" clean;\
	done
.PHONY: clean_archs
