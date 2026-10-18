#------------------------------------------------------------------------------
#
#  \brief   hello-World recipe for tcbuilder
#
#           Test the toolchain
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.hello_world_issue		$(DONE_PATH) $(GENERIC_DONE_PATH)


hello_world.ENVIRONMENT                =$(cross.ENVIRONMENT)

ifeq ($(NOSTDLIB),yesX)
HELLO_ARGS     = -nostdlib $(OPWD)/src/dummy_syscalls.c  \
               -Wl,--just-symbols=$(OPWD)/src/symbols.map \
               -lc
else
HELLO_ARGS     =
endif

MAKEFILE_DIR							= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SELF_DIR_hello_world					:= $(PWD)/$(dir $(lastword $(MAKEFILE_LIST)))


# Its a little bit sensitive if not all libraries/compile-units want the same 
# lto settings

HELLO_FLAGS		= \
						-flto \
						-fuse-linker-plugin \
						-fno-builtin \
						--save-temps \
						-O0 \
						$(TARGET_ARCHFLAGS) \
						-D$(TCB_TARGET_PLATFORM) \
						-D$(LIBC_PROVIDER)

HELLO_FLAGS     = -flto \
						-fuse-linker-plugin \

# Keep this empty for debugging. Avoid rebuilding gcc every time picolibc was rebuild.
HW_REQUIRED			= gcc.issue libc.issue

%.hello_world_c_su.issue: $(HW_REQUIRED) $(SELF_DIR_hello_world)/files/src/hello.c
	@mkdir -p $(BUILD_PATH)/$*
	@cd $(BUILD_PATH)/$*; $(do_export) $(C_FOR_TARGET) \
				$(HELLO_FLAGS) \
				$(SELF_DIR_hello_world)/files/src/hello.c \
				$(SELF_DIR_hello_world)/files/src/dummy_syscalls.c \
				$(SELF_DIR_hello_world)/files/src/picolibc_symbols.c \
				-Wl,--just-symbols=$(SELF_DIR_hello_world)/files/src/symbols.map \
				-o $(BUILD_PATH)/$*/hello_c_su \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	$(done)

# $(OPWD)/src/hello_snprintf.c

%.hello_world_snprintf.issue: $(HW_REQUIRED) $(SELF_DIR_hello_world)/files/src/hello_snprintf.c
	@mkdir -p $(BUILD_PATH)/$*
	@cd $(BUILD_PATH)/$*; $(do_export) $(GCC_FOR_TARGET) \
				$(HELLO_FLAGS) \
				$(SELF_DIR_hello_world)/files/src/hello_snprintf.c \
				$(SELF_DIR_hello_world)/files/src/picolibc_symbols.c \
				-o $(BUILD_PATH)/$*/hello_snprintf \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	$(done)

%.hello_world_c.issue: $(HW_REQUIRED) $(SELF_DIR_hello_world)/files/src/hello.c
	@mkdir -p $(BUILD_PATH)/$*
	@cd $(BUILD_PATH)/$*; $(do_export) $(C_FOR_TARGET) \
				$(HELLO_FLAGS) \
				$(SELF_DIR_hello_world)/files/src/hello.c \
				-c -o $(BUILD_PATH)/$*/hello_c.o \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	@cd $(BUILD_PATH)/$*; $(do_export) $(C_FOR_TARGET) \
				$(HELLO_FLAGS) \
				$(SELF_DIR_hello_world)/files/src/dummy_syscalls.c \
				-c -o $(BUILD_PATH)/$*/dummy_syscalls.o \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	@cd $(BUILD_PATH)/$*; $(do_export) $(C_FOR_TARGET) \
				$(HELLO_FLAGS) \
				$(SELF_DIR_hello_world)/files/src/picolibc_symbols.c \
				-c -o $(BUILD_PATH)/$*/picolibc_symbols.o \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	@cd $(BUILD_PATH)/$*; $(do_export) $(GCC_FOR_TARGET) \
				$(HELLO_FLAGS) \
				-Wl,--just-symbols=$(SELF_DIR_hello_world)/files/src/symbols.map \
				$(BUILD_PATH)/$*/hello_c.o \
				$(BUILD_PATH)/$*/dummy_syscalls.o \
				$(BUILD_PATH)/$*/picolibc_symbols.o \
				-o $(BUILD_PATH)/$*/hello_c \
				$(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	$(done)

# 				-nostdlib -lc \

# $(OPWD)/src/picolibc_symbols.c \
# $(_HELLO_ARGS) \
# -nostdlib \
# $(OPWD)/src/dummy_syscalls.c  \
# -Wl,--just-symbols=$(OPWD)/src/symbols.map \
# -flto \
# -fuse-linker-plugin \
# -fno-builtin \
# -lm \

# -flto -fuse-linker-plugin \
# -fuse-ld=gold

# 		$(LDFLAGS_FOR_TARGET)
#   -fno-exceptions:
#
%.hello_world_cpp.issue: $(HW_REQUIRED) $(SELF_DIR_hello_world)/files/src/hello.cpp
	@mkdir -p $(BUILD_PATH)/$*
	@cd $(BUILD_PATH)/$*; $(do_export) $(CXX_FOR_TARGET) \
			$(TARGET_ARCHFLAGS) \
        $(SELF_DIR_hello_world)/files/src/hello.cpp \
		  $(SELF_DIR_hello_world)/files/src/dummy_syscalls.c \
		  $(SELF_DIR_hello_world)/files/src/picolibc_symbols.c \
               $(HELLO_ARGS) \
					-flto \
					-fuse-linker-plugin \
					-o $(BUILD_PATH)/$*/hello_cpp \
					$(LOG_REDIRECT) \
                || $(call dumpAndFail,Could not compile,"$(LOG_FILE)")
	$(done)


hello_world.hello_world.issue: hello_world.hello_world_c.issue hello_world.hello_world_cpp.issue hello_world.hello_world_snprintf.issue
hello_world.hello_world.clean: hello_world.hello_world_c.clean hello_world.hello_world_cpp.clean hello_world.hello_world_snprintf.clean

%.hello_world.issue: 
	$(done)

hello_world.issue: hello_world.hello_world.issue
	$(done)


#---fin------------------------------------------------------------------------
