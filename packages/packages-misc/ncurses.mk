#------------------------------------------------------------------------------
#
#  \brief   NCurses recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


ncurses.VERSION                   = 6.6
ncurses.ARCHIVE_FILE              = ncurses-$(ncurses.VERSION).tar.gz
ncurses.ARCHIVE_URL               = $(GNU_MIRROR)/ncurses/$(ncurses.ARCHIVE_FILE)
ncurses.ENTRY_PATH                = ncurses-$(ncurses.VERSION)
ncurses.SOURCE_PATH               = ncurses-$(ncurses.VERSION)
ncurses.CONFIGURE_BASEFLAGS       = \
											$(target.CONFIGUREFLAGS) \
											--with-shared \
											--prefix=$(TARGET_PREFIX) \
											--includedir=$(TARGET_PREFIX)/include \
											--libdir=$(TARGET_PREFIX)/lib \
											--enable-pc-files \
											--with-pkg-config-libdir=/usr/lib/pkgconfig \
											--without-ada \
											--without-tests \
											--with-pkg-config

ncurses.CONFIGUREFLAGS       = \
												$(ncurses.CONFIGURE_BASEFLAGS) \
												--with-termlib=tinfo \
												--without-progs \
                                    --with-shlib-version \
                                    --with-versioned-syms \
                                    --with-libtool

ncurses.ENVIRONMENT					=	$(target.ENVIRONMENT)
ncurses.MAKE_TARGET	            =libs
ncurses.ADDITIONAL_MAKE_TARGET   =sources
PACKAGES                         += ncurses ncurses-host ncursesw

$(eval $(call template,ncurses-host,host))
$(eval $(call template,ncursesw-host,host))

ncurses-host.VERSION                   =  $(ncurses.VERSION)
ncurses-host.SOURCE_PATH					=  $(ncurses.SOURCE_PATH)

# --enable-widec: python-curses uses it. It will be provided by ncursesw
# --with-termlib=tinfo: gdb needs libtinfo
ncurses-host.CONFIGUREFLAGS            +=  \
                                    --includedir=$(TARGET_PREFIX)/include \
                                    --with-termlib=tinfo \
                                    --enable-pc-files \
                                    --disable-termcap \
                                    --without-cxx-binding \
                                    --with-shared \
                                    --with-termlib \
                                    --with-pkg-config \
                                    --with-shlib-version \
                                    --with-versioned-syms \
                                    --disable-widec

ncurses-host.MAKE_TARGET					=$(ncurses.MAKE_TARGET)
ncurses-host.ADDITIONAL_MAKE_TARGET		=$(ncurses.ADDITIONAL_MAKE_TARGET)

ncursesw.VERSION                   =  $(ncurses.VERSION)
ncursesw.SOURCE_PATH					=  $(ncurses.SOURCE_PATH)
ncursesw.CONFIGURE_BASEFLAGS            =  $(ncurses.CONFIGURE_BASEFLAGS) \
                                    --disable-termcap \
                                    --enable-widec \
                                    --without-progs
ncursesw.CONFIGUREFLAGS            +=  $(ncursesw.CONFIGURE_BASEFLAGS)

ncursesw.CPPFLAGS_FOR_TARGET				=$(ncurses.CPPFLAGS_FOR_TARGET)
ncursesw.ENVIRONMENT					=$(ncurses.ENVIRONMENT)
ncursesw.MAKE_TARGET					=$(ncurses.MAKE_TARGET)
ncursesw.ADDITIONAL_MAKE_TARGET		=$(ncurses.ADDITIONAL_MAKE_TARGET)

ncursesw-host.VERSION                   =  $(ncurses.VERSION)
ncursesw-host.SOURCE_PATH					=  $(ncurses.SOURCE_PATH)
ncursesw-host.CONFIGUREFLAGS          +=  $(ncursesw.CONFIGURE_BASEFLAGS)

ncurses-host.MAKE_TARGET					=$(ncurses.MAKE_TARGET)
ncurses-host.ADDITIONAL_MAKE_TARGET		=$(ncurses.ADDITIONAL_MAKE_TARGET)


$(eval $(call useOwnLd, ncurses-host))
$(eval $(call useOwnLd, ncursesw-host))

ncurses.sourcebase: ncurses.archive_sourcebase
ncursesw.sourcebase: ncurses.archive_sourcebase
ncursesw.veryclean: ncurses.veryclean

ncurses-host.sourcebase: ncurses.sourcebase
ncurses-host.veryclean: ncurses.veryclean
ncurses-host.cmi_configure: glibc_native.issue libtool.issue
ncurses-host.clean: ncurses.clean

ncursesw-host.sourcebase: ncursesw.sourcebase
ncursesw-host.veryclean: ncursesw.veryclean
ncursesw-host.cmi_configure: glibc_native.issue libtool.issue
ncursesw-host.clean: ncursesw.clean

ncurses.configure: gmp.issue mpfr.issue
ncursesw.configure: gmp.issue mpfr.issue

ncurses.issue: ncurses.cmi
	$(done)

ncursesw.issue: ncursesw.cmi
	$(done)

ncurses-host.veryclean: ncurses.veryclean

ncurses-host.issue: ncurses-host.cmi
	$(RUN_LDCONFIG)
	$(done)

ncursesw-host.issue: ncursesw-host.cmi
	$(RUN_LDCONFIG)
	$(done)


#---fin------------------------------------------------------------------------
