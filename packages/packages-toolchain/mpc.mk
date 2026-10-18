#------------------------------------------------------------------------------
#
#  \brief   Mpc recipe for tcbuilder
#
#           URL: https://ftp.gnu.org/gnu/mpc/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


mpc.VERSION                   := 1.4.1
mpc.ARCHIVE_FILE              := mpc-$(mpc.VERSION).tar.xz
mpc.ARCHIVE_URL               := $(GNU_MIRROR)/mpc/$(mpc.ARCHIVE_FILE)
mpc.SOURCE_PATH               := mpc-$(mpc.VERSION)
mpc.SCOPE                     = local

$(eval $(call Package,mpc))
$(eval $(call template,mpc,host))

mpc.CONFIGUREFLAGS            += \
                                  --disable-shared \
                                  --enable-static

mpc.sourcebase:     mpc.archive_sourcebase
mpc.sourcetree:     mpc.sourcebase_patched
mpc.preconfigure:    gmp.issue mpfr.issue
mpc.install:        mpc.cmi mpc.remove_la

mpc.issue: mpc.skeleton
	$(done)


#---fin------------------------------------------------------------------------
