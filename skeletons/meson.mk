#------------------------------------------------------------------------------
#
# \brief    handles meson/ninja based projects in tcbuilder2
#
#				...
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20171214> file created
#
#------------------------------------------------------------------------------


vpath		%.meson					$(DONE_PATH)
vpath		%.meson_predepend		$(DONE_PATH)

target.MESONFLAGS				= --cross-file $(BUILD_PATH)/meson/meson-tcb-cross-file.txt
MESON_RAW_THREADS				= $(shell nproc)
MESON_THREADS					= $(shell echo $(MESON_RAW_THREADS))

precondition: mesonSkeleton.precondition

SELF_DIR_sk_meson							:= $(PWD)/$(dir $(lastword $(MAKEFILE_LIST)))

mesonSkeleton.precondition: setup_generic
	$(silentGenericDone)

%.meson_predepend: %.sourcetree
	$(silentGenericDone)

# Yep, there is only one single cross file for all
meson_cross_file.issue:
	@mkdir -p $(BUILD_PATH)/meson
	@#echo "Error: SELF_DIR: $(SELF_DIR)"
	@#echo "Error: SELF_DIR_meson: $(SELF_DIR_meson)"
	@cp $(SELF_DIR_sk_meson)/files/meson-cross-file.txt.in $(BUILD_PATH)/meson/meson-tcb-cross-file.txt
	@sed  \
		-e 's|@TARGET_PKG_CONFIG_RUNTIME@|$(TARGET_PKG_CONFIG_RUNTIME)|g' \
		-e 's|@CROSSTOOLS_BIN_PREFIX@|$(CROSSTOOLS_BIN_PREFIX)|g' \
		-e 's|@CROSS_COMPILE@|$(CROSS_COMPILE)|g' \
		-e 's|@SYSROOT_HOST@|$(SYSROOT_HOST)|g' \
		-e 's|@MICROARCHITECTURE@|$(MICROARCHITECTURE)|g' \
		-e 's|@TARGET_CPU@|$(tcb.TARGET_CPU)|g' \
		-i $(BUILD_PATH)/meson/meson-tcb-cross-file.txt $(LOG_REDIRECT)
	$(done)

# meson.issue: Install the meson binary
%.meson: %.meson_predepend meson_cross_file.issue meson.issue
	$(call lHint,Building via meson $*)
	@mkdir -p $(B)
	@echo "Meson Flags: $($*.MESONFLAGS)" $(LOG_REDIRECT)
	@echo "   Threads: $(MESON_THREADS)" $(ADD_LOG_REDIRECT)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); \
		$(do_export) meson \
					--prefix /usr \
					--libdir /usr/lib \
					--includedir /usr/include \
					$($*.MESONFLAGS) \
					$(B) $(ADD_LOG_REDIRECT)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); \
		$(do_export) ninja -j$(MESON_THREADS) -C $(B) $($*.MAKE_TARGET) $(ADD_LOG_REDIRECT)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); \
		$(do_export) DESTDIR="$($*.DESTDIR)" ninja -j $(MESON_THREADS) -C $(B) install $(ADD_LOG_REDIRECT)
	$(done)


#---fin------------------------------------------------------------------------
