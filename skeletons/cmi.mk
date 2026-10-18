#------------------------------------------------------------------------------
#
# \brief    handles autotools based projects in tcbuilder3
#
#           Builds autotools based packages.
#           BTW: "CMI" stands for configure, make, install.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.cmi_predepend		$(GENERIC_DONE_PATH)
vpath		%.cmi_configure		$(DONE_PATH)
vpath		%.cmi_make				$(DONE_PATH)
vpath		%.cmi_make_install	$(DONE_PATH)
vpath		%.cmi						$(DONE_PATH)
vpath		%.autogen				$(DONE_PATH)
vpath		%.autoreconf			$(DONE_PATH)
vpath		%.intltoolize			$(DONE_PATH)
vpath		%.bootstrap				$(DONE_PATH)
vpath		%.workaround			$(DONE_PATH)
vpath		%.autoreconf			$(DONE_PATH)
vpath		%.custom_build			$(DONE_PATH)
vpath		%.custom_make			$(DONE_PATH)
vpath		%.custom_step			$(DONE_PATH)
vpath		%.cmi_make_additional_target	$(DONE_PATH)
vpath		%.cmi_make_precedent_target	$(DONE_PATH)
vpath		%.custom_install		$(DONE_PATH)
vpath		%.custom_configure	$(DONE_PATH)
vpath		%.custom_config		$(DONE_PATH)
vpath		%.remove_la				$(DONE_PATH)
vpath		%.libtoolize			$(DONE_PATH)


precondition: cmi.precondition

cmi.precondition: setup_generic
	$(silentGenericDone)


#	@if [ ! -e "/usr/bin/libtool" ]; then \
#		echo "Error: libtool not installed."; \
#      echo "       sudo apt-get install -y libtool-bin"; \
#		exit 22; \
#	fi

#--- Targerts


# Script can set own rules on how to set up the archive
# %.cmi_predepend: %.predepend
%.cmi_predepend: %.sourcetree
	$(silentGenericDone)


#	[ "$($*.CMI_CONFIGURE_BASH)" != "yes" ] || ( cd $(BUILD_PATH)/$*-$($*.VERSION); \
#		echo "Flags: $($*.CONFIGUREFLAGS) $(CONFIGUREFLAGS) "; \
#		$(do_export) bash );
# $(do_export) export

%.cmi_configure: %.preconfigure %.cmi_predepend
	$(call lHint,configuring $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@if [ "$($*.BUILD_IN_SOURCE)" = "yes" ]; then \
		configurePath=./$($*.SUBDIR); \
		rm -rf $(BUILD_PATH)/$*-$($*.VERSION); \
		cp -R $(SOURCE_PATH)/$($*.SOURCE_PATH) $(BUILD_PATH)/$*-$($*.VERSION); \
	else \
		configurePath=$(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); \
	fi; \
	if [ ! "$($*.NO_CONFIGURE)" = "yes" ]; then \
		cd $(BUILD_PATH)/$*-$($*.VERSION); [ ! -e Makefile ] || $(MAKE) distclean $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_distclean.log | true; \
		cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) export \
				$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_configure_environment.txt; \
		cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $$configurePath/[c,C]onfigure \
				--help $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_configure_help.txt || $(call lsWarn, Could not generate help for configure); \
		cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) TEST=TOST declare -x \
						 $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_env.txt || echo Could not store environment; \
					 cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $$configurePath/[c,C]onfigure \
                                $($*.CONFIGUREFLAGS) $(CONFIGUREFLAGS) $(LOG_REDIRECT) \
				|| $(call dumpAndFail,Could not configure,"$(LOG_FILE)"); \
	else \
		$(call lsHint,Skipping due to settings) \
	fi
	$(silentDone)


%.cmi_make: %.cmi_configure
	$(call lHint,Start compiling $* (target '$($*.MAKE_TARGET)'))
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@[ "$($*.CMI_MAKE_BASH)" != "yes" ] || ( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) bash )
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $(SUB_MAKEFLAGS) $($*.MAKE_TARGET) $($*.MAKE_ARGS) $(LOG_REDIRECT) \
	|| $(call dumpAndFail,Could not make,"$(LOG_FILE)");
	$(silentDone)


%.devshell: %.prebuild
	$(call lHint,Start devshell $* (target '$($*.MAKE_TARGET)'))
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) bash )

%.cmi_make_precedent_target: %.cmi_configure
	$(call lHint,Start compiling additional target $*: $($*.PRECEDENT_MAKE_TARGET))
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $($*.PRECEDENT_MAKE_TARGET) $(SUB_MAKEFLAGS) $(LOG_REDIRECT) \
	|| $(call dumpAndFail,Could not make additional target,"$(LOG_FILE)");
	$(silentDone)


%.cmi_make_additional_target: %.cmi_make
	$(call lHint,Start compiling additional target $*: $($*.ADDITIONAL_MAKE_TARGET))
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $($*.ADDITIONAL_MAKE_TARGET) $(SUB_MAKEFLAGS) $(LOG_REDIRECT) \
	|| $(call dumpAndFail,Could not make additional target,"$(LOG_FILE)");
	$(silentDone)


# autogen needs aclocal which is in automake
%.autogen: %.cmi_predepend libtool.issue automake.issue
	$(call lHint,Autogen $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(do_export) $(automake.USE_ENVIRONMENT) NOCONFIGURE=yes $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR)/autogen.sh $($*.AUTOGEN_ARGS) \
			$($*.CONFIGUREFLAGS) $(CONFIGUREFLAGS) $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_autogen.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); [ ! -e "Makefile" ] || ( $(MAKE) distclean &> /dev/null || echo "ignoring, distclean not that important" &> /dev/null )
	@#cd $(SOURCE_PATH)/$($*.SOURCE_PATH); [ ! -z "$($*.RECO_CONFIGURE)" ] && git checkout configure
	$(silentDone)


%.autoreconf: %.cmi_predepend
	$(call lHint,Autoreconf $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) export \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_autoreconf_env.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) autoreconf -i -v --force --install \
			$($*.AUTORECONF_ARGS) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_autoreconf.log
	$(call lHint,Autoreconfiguring $* done)
	$(silentDone)

%.autoconf: %.cmi_predepend
	$(call lHint,Autoreconf $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) autoconf -f \
			$($*.AUTORECONF_ARGS) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_autoreconf.log
	$(call lHint,Autoreconfiguring $* done)
	$(silentDone)

%.intltoolize: %.autoreconf
	$(call lHint,intltoolize $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) intltoolize --force \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_intltoolize.log
	$(call lHint,intltoolize $* done)
	$(silentDone)


%.bootstrap: %.cmi_predepend
	$(call lHint,Bootstraping $*)
	@bootstrap=$($*.BOOTSTRAP_COMMAND); [ ! -z "$$bootstrap" ] || bootstrap=bootstrap; \
			cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$($*.BOOTSTRAP_ENVIRONMENT) $(do_export) export \
				$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_bootstrap_environment.log; \
			$($*.BOOTSTRAP_ENVIRONMENT) $(do_export) /usr/bin/bash --version $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_bash.log; \
			$($*.BOOTSTRAP_ENVIRONMENT) $(do_export) ./$$bootstrap $($*.BOOTSTRAP_ARGS) \
				$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_bootstrap.log
	$(call lHint,Bootstraping $* done)
	$(silentDone)

#			echo "### aclocal"; aclocal --force -I m4 -I acinclude;
#echo "### aclocal"; aclocal --force -I acinclude; \
#echo "### libtoolize"; libtoolize --force; \
#echo "### autoheader"; autoheader; \
#echo "### autoconf"; autoconf ) \

%.libtoolize: %.cmi_predepend
	$(call lHint,Libtoolize $*)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) (  \
			echo "## libtoolize"; libtoolize --force --install; \
			incpath=.; \
			[ -e "m4" ] && incpath=m4; \
			[ -e "acinclude" ] && incpath=acinclude; \
			echo "## aclocal"; aclocal --force -I $$incpath; \
			echo "## automake"; automake --add-missing; \
			echo "## autoreconf"; autoreconf -ivf ) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_libtoolize.log
	$(call lHint,Bootstraping $* done)
	$(silentDone)

%.autoconf2: %.cmi_predepend
	$(call lHint,Libtoolize $*)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH)/$($*.SUBDIR); $(do_export) (  \
		rm -f aclocal.m4; aclocal && libtoolize --force && autoreconf ) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_autoconf2.log
	$(call lHint,Bootstraping $* done)
	$(silentDone)

%.cmi_make_install: %.cmi_make %.build %.pkginfo
	$(call lHint,Installing $*)
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)
	@[ -z "$(SYSROOT)" ] || mkdir -p $(SYSROOT)
	@if [ ! "$($*.NO_MAKE_INSTALL)" = "yes" ]; then \
		cd $(BUILD_PATH)/$*-$($*.VERSION); \
		$(do_export) $(MAKE) install $($*.MAKE_INSTALL_TARGETS) DESTDIR="$($*.DESTDIR)" $($*.MAKE_ARGS) $(call redirect,"$(LOG_PATH)/$*_make_install.log") \
		|| $(call dumpAndFail,Could not install,"$(LOG_PATH)/$*_make_install.log"); \
	else \
		$(call lsHint,Skipping due to settings) \
	fi
	@[ -z "$($*.ADDITIONAL_MAKE_INSTALL_TARGETS)" ] || \
		( cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) $($*.ADDITIONAL_MAKE_INSTALL_TARGETS) DESTDIR="$($*.DESTDIR)" $(SUB_MAKEFLAGS) $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_install_additional.log )
	$(silentDone)


%.remove_la: %.cmi_make_install
	@cd .; $(do_export) rm $($*.DESTDIR)/$(HOST_PREFIX)/lib/lib$*.la || true
	$(silentDone)


%.cmi: %.cmi_make_install
	$(silentDone)


#---fin------------------------------------------------------------------------
