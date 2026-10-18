#------------------------------------------------------------------------------
#
# \brief    Installs 'mkspecs' for qmake, cmake tool chain file and linker scripts
#
#           Files are usually installed in "/usr/share/qt4/mkspecs/"
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


SELF_DIR							:= "$(PWD)/$(dir $(lastword $(MAKEFILE_LIST)))"

mkspecs.package_start:  precondition
	@echo done >> "$(GENERIC_DONE_PATH)/$@"

mkspecs.install_mkspecs.target: mkspecs.build
	@mkdir -p $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/qt4/mkspecs
	@cd $(SELF_DIR)/files/mkspecs; for directory in *; do \
		$(call lsHint,Installing Spec $$directory); \
		rm -rf $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/qt4/mkspecs/$$directory; \
		ln -s $$PWD/$$directory $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/qt4/mkspecs/$$directory; \
	done
	$(done)

mkspecs.install: mkspecs.install_mkspecs.target

mkspecs.issue: mkspecs.skeleton
	$(done)


cmake_scripts.package_start:  precondition
	@echo done >> "$(GENERIC_DONE_PATH)/$@"

cmake_scripts.install_cmake_scripts.target: cmake_scripts.build ldscripts.install
	@mkdir -p $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/cmake/Modules
	@cd $(SELF_DIR)/files/cmake; for file in *; do \
		$(call lsHint,Installing cmake file $$file); \
		rm -rf $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/cmake/Modules/$$file; \
	cat $$PWD/$$file | sed -e "s/@@LOCAL_TUNE@@/$(LOCAL_TUNE)/g" \
	    -e "s/@@TCB_RELEASE@@/$(RELEASE)/g" \
	> $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/cmake/Modules/$$file; \
	done
	$(done)

cmake_scripts.install: cmake_scripts.install_cmake_scripts.target

cmake_scripts.issue: cmake_scripts.skeleton
	$(done)


ldscripts.package_start:  precondition
	@echo done >> "$(GENERIC_DONE_PATH)/$@"

ldscripts.install_ldscripts.target: ldscripts.build
	@mkdir -p $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/tcbuilder3
	@mkdir -p $(INSTALLROOT_TARGET)$(TARGET_NONUSR_PREFIX)/lib
	@cd $(SELF_DIR)/files/linkerscripts; for file in *; do \
		$(call lsHint,Installing linker script $$file); \
		rm -rf $(INSTALLROOT_HOST)$(HOST_PREFIX)/share/tcbuilder3/$$file; \
		cp $$PWD/$$file $(INSTALLROOT_TARGET)$(TARGET_NONUSR_PREFIX)/lib/$$file; \
	done
	$(done)

ldscripts.install: ldscripts.install_ldscripts.target


#---fin------------------------------------------------------------------------
