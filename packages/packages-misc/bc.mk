#------------------------------------------------------------------------------
#
#  \brief   bc recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#-----------------------------|------------------------------------------------


bc.VERSION						=	1.08.2
bc.ARCHIVE_FILE				=	bc-$(bc.VERSION).tar.gz
bc.ARCHIVE_URL				=	https://ftp.gnu.org/gnu/bc/$(bc.ARCHIVE_FILE)
bc.ENTRY_PATH					=	bc-$(bc.VERSION)
bc.SOURCE_PATH				=	bc-$(bc.VERSION)
bc.CONFIGUREFLAGS			=	$(target.CONFIGUREFLAGS)
bc.ENVIRONMENT				=	$(target.ENVIRONMENT)
# bc.pkg-config_LIBNAME		= libffi

bc-host.VERSION				=	$(bc.VERSION)
bc-host.SOURCE_PATH			=	$(bc.SOURCE_PATH)
bc-host.CONFIGUREFLAGS		=	$(host.CONFIGUREFLAGS)
bc-host.ENVIRONMENT				=	$(host.ENVIRONMENT)

$(eval $(call template,bc-host,host))

bc.sourcebase: bc.archive_sourcebase

# bc.pkg-config_file
bc.issue: bc.cmi
	$(done)


bc-host.sourcebase: bc.sourcebase

bc-host.issue: bc-host.cmi
	$(done)
	
bc-host.veryclean: bc.veryclean


#---fin------------------------------------------------------------------------
