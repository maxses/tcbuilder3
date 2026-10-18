#------------------------------------------------------------------------------
#
#  \brief   Meta recipe for tcbuilder
#
#           Creates meta file with some information about toolchain
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


META_FILE       =   $(SYSROOT_HOST)$(HOST_PREFIX)/share/tcbuilder3/tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)-$(DATECODE).meta.txt

meta.ENVIRONMENT                =$(cross.ENVIRONMENT)

#ifeq ($(NOSTDLIB),yes)
META_ARGS     = -nostdlib $(OPWD)/src/dummy_syscalls.c  \
               -Wl,--just-symbols=$(OPWD)/src/symbols.map \
               -lc
#else
#META_ARGS     =
#endif

MAKEFILE_DIR_meta := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

%.meta.issue: gcc.issue libc.issue toolchain.issue $(MAKEFILE_DIR_meta)/files/src/hello.cpp
	@echo -n > $(META_FILE)
	@echo "//--------------------------------------------------" >> $(META_FILE)
	@echo "//                                                  " >> $(META_FILE)
	@echo "//   Meta file for toolchain                        " >> $(META_FILE)
	@echo "//   tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)" >> $(META_FILE)
	@echo "//                                                  " >> $(META_FILE)
	@echo "//   Just some info about the compiler              " >> $(META_FILE)
	@echo "//                                                  " >> $(META_FILE)
	@echo "//--------------------------------------------------" >> $(META_FILE)
	@echo >> $(META_FILE)
	@$(MAKE) info >> $(META_FILE)
	@echo >> $(META_FILE)
	@$(do_export) $(C_FOR_TARGET) -v &>> $(META_FILE)
	@echo; echo >> $(META_FILE)
	@echo "CFLAGS_FOR_TARGET: $(CFLAGS_FOR_TARGET)" >> $(META_FILE)
	@echo "CXXFLAGS_FOR_TARGET: $(CXXFLAGS_FOR_TARGET)" >> $(META_FILE)
	@echo >> $(META_FILE)
	@mkdir -p $(BUILD_PATH)/$*
	@cd $(BUILD_PATH)/$*; $(do_export) $(C_FOR_TARGET) \
		$(TARGET_ARCHFLAGS) \
		-D$(TCB_TARGET_PLATFORM) \
		-D$(LIBC_PROVIDER) \
		$(MAKEFILE_DIR_meta)/files/src/hello.c \
		$(MAKEFILE_DIR_meta)/files/src/picolibc_symbols.c \
		$(_HELLO_ARGS) \
		-nostdlib \
		$(MAKEFILE_DIR_meta)/files/src/dummy_syscalls.c  \
		-Wl,--just-symbols=$(MAKEFILE_DIR_meta)/files/src/symbols.map \
		-flto \
		-save-temps \
		-fuse-linker-plugin \
		-lm \
		-o /tmp/hello $(LOG_REDIRECT) \
		|| $(call dumpAndFail,Could not install,"$(LOG_FILE)")
	@cd $(BUILD_PATH)/$*; cat /tmp/hello-hello.s | grep -e ".cpu " -e ".fpu " -e ".thumb"  >> $(META_FILE)
	@echo >> $(META_FILE)
	@cd $(BUILD_PATH)/$*; $(do_export) $(READELF_FOR_TARGET) -A /tmp/hello >> $(META_FILE)
	@echo >> $(META_FILE)
	@echo "//---fin.-------------------------------------------" >> $(META_FILE)
	$(done)

meta.issue: meta.meta.issue
	$(done)

#---fin------------------------------------------------------------------------
