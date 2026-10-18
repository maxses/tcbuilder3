#------------------------------------------------------------------------------
#
#  \brief   Gengetopt recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


gengetopt.VERSION                   = 2.23.1
gengetopt.ARCHIVE_FILE              = gengetopt-$(gengetopt.VERSION).tar.xz
gengetopt.ARCHIVE_URL               = https://ftp.gnu.org/gnu/gengetopt/$(gengetopt.ARCHIVE_FILE)
gengetopt.SOURCE_PATH               = gengetopt-$(gengetopt.VERSION)
gengetopt.SCOPE                     = local


gengetopt.CONFIGUREFLAGS					+=	$(host.CONFIGUREFLAGS)
gengetopt.ENVIRONMENT                 +=	$(host.ENVIRONMENT)
gengetopt.DESTDIR                     =	$(host.DESTDIR)

$(eval $(call Package,gengetopt))

gengetopt.sourcebase:     gengetopt.archive_sourcebase
gengetopt.sourcetree:     gengetopt.sourcebase_patched

gengetopt.issue: gengetopt.cmi
	$(done)

# gengetopt configure step needs makeinfo: texinfo
gengetopt.cmi_configure: texinfo.issue


#---fin------------------------------------------------------------------------
