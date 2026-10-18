#------------------------------------------------------------------------------
#
# \brief    handles cmake projects in tcbuilder3
#
#           builds cmake based packages
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.cmake_predepend		$(GENERIC_DONE_PATH)
vpath		%.cmake_init			$(DONE_PATH)
vpath		%.cmake_configure			$(DONE_PATH)
vpath		%.cmake_make			$(DONE_PATH)
vpath		%.cmake_install		$(DONE_PATH)
vpath		%.cmake					$(DONE_PATH)



default.CMAKE_ARGS				=\
											-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
											-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
											-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
											-DSTACK_DIRECTION=1

target.CMAKE_ARGS					=-G "Unix Makefiles" \
												-DCMAKE_INSTALL_PREFIX=$(TARGET_PREFIX) \
												-DCMAKE_CROSSCOMPILING=TRUE \
												-DCMAKE_SYSTEM_VERSION=1 \
												-DCMAKE_SYSTEM_NAME=Linux \
												-DCMAKE_C_COMPILER=$(C_FOR_TARGET) \
												-DCMAKE_CXX_COMPILER=$(CXX_FOR_TARGET) \
												-DCMAKE_MAKE_PROGRAM=/usr/bin/make \
												-DCMAKE_SYSROOT=$(SYSROOT_TARGET) \
												-DCMAKE_FIND_ROOT_PATH=$(SYSROOT_TARGET) \
												-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
												-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY

host.CMAKE_ARGS					=-G "Unix Makefiles" \
												-DCMAKE_INSTALL_PREFIX=$(HOST_PREFIX) \
												-DCMAKE_SYSTEM_VERSION=1 \
												-DCMAKE_SYSTEM_NAME=Linux \
												-DCMAKE_SYSROOT=$(SYSROOT_HOST) \
												-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
												-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY

native.CMAKE_ARGS					=-G "Unix Makefiles" \
												-DCMAKE_INSTALL_PREFIX=$(HOST_PREFIX) \
												-DCMAKE_SYSTEM_VERSION=1 \
												-DCMAKE_SYSTEM_NAME=Linux \
												-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
												-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
												-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY

host.CMAKE_ARGS_LOCAL				=	-G "Unix Makefiles" \
												-DCMAKE_INSTALL_PREFIX=$(HOST_PREFIX) \
												-DCMAKE_SYSTEM_VERSION=1 \
												-DCMAKE_SYSTEM_NAME=Linux \

#												-CMAKE_SYSTEM_PROCESSOR=arm \
#

precondition: cmakeSkeleton.precondition

cmakeSkeleton.precondition: setup_generic
	$(silentGenericDone)

# Script can set own rules on how to set up the archive
%.cmake_predepend: %.sourcetree
	$(silentGenericDone)


%.cmake_configure: %.cmake_predepend cmake_host.issue %.preconfigure
	$(call lHint,configuring $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@if [ "$($*.BUILD_IN_SOURCE)" = "yes" ]; then \
		configurePath=.; \
		rm -rf $(BUILD_PATH)/$*-$($*.VERSION); \
		cp -R $(SOURCE_PATH)/$($*.SOURCE_PATH) $(BUILD_PATH)/$*-$($*.VERSION); \
	else \
		configurePath=$(SOURCE_PATH)/$($*.SOURCE_PATH); \
	fi; \
	rm -f $(BUILD_PATH)/$*-$($*.VERSION)/CMakeCache.txt; \
	echo 'cmake $($*.CMAKE_ARGS) $$configurePath/$($*.SUBDIR)' \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_cmake_cl.log; \
	cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) export \
				$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_cmake_export.log; \
	cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) cmake $($*.CMAKE_ARGS) $$configurePath/$($*.SUBDIR) \
				$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_cmake.log
	$(silentDone)

%.cmake_devshell: %.prebuild
	$(call lHint,Start devshell $* (target '$($*.MAKE_TARGET)'))
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@echo cmake $($*.CMAKE_ARGS) $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR) > $(BUILD_PATH)/$*-$($*.VERSION)/build.sh
	@echo cat $(BUILD_PATH)/$*-$($*.VERSION)/build.sh
	@( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) bash )


%.cmake_make: %.cmake_configure %.configure
	$(call lHint,Start compiling $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@echo make $(SUB_MAKEFLAGS) $($*.MAKE_TARGET) $($*.MAKE_ARGS) > $(LOG_PATH)/$*_make_cl.log
	@echo '$(do_export)' >> $(LOG_PATH)/$*_make_cl.log
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $(SUB_MAKEFLAGS) $($*.MAKE_TARGET) $($*.MAKE_ARGS) $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make.log
	@[ -z "$($*.ADDITIONAL_MAKE_TARGET)" ] || \
		( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $($*.ADDITIONAL_MAKE_TARGET) $(SUB_MAKEFLAGS) $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_additional.log )
	$(silentDone)


%.cmake_install: %.cmake_make %.pkginfo
	$(call lHint,Installing $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@mkdir -p $(ROOTFS_PATH)
	@if [ ! "$($*.NO_MAKE_INSTALL)" = "yes" ]; then \
					 cd $(BUILD_PATH)/$*-$($*.VERSION); \
					 $(do_export) $(MAKE) install DESTDIR="$($*.DESTDIR)" \
								$($*.MAKE_ARGS) $(REDIRECTION_STATEMENT) \
								$(LOG_PATH)/$*_make_install.log; \
	else \
		$(call lsHint,Skipping due to settings) \
	fi
	@[ -z "$($*.ADDITIONAL_MAKE_INSTALL_TARGETS)" ] || \
		( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $($*.ADDITIONAL_MAKE_INSTALL_TARGETS) $(SUB_MAKEFLAGS) $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_install_additional.log )
	$(silentDone)


%.cmake: %.cmake_install
	$(silentDone)


#---fin------------------------------------------------------------------------
