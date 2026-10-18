#------------------------------------------------------------------------------
#
#  \brief   libffi recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#-----------------------------|------------------------------------------------


libffi.VERSION						=	3.4.5
libffi.ARCHIVE_FILE				=	libffi-$(libffi.VERSION).tar.gz
libffi.ARCHIVE_URL				=	https://github.com/libffi/libffi/releases/download/v$(libffi.VERSION)/$(libffi.ARCHIVE_FILE)
libffi.ENTRY_PATH					=	libffi-$(libffi.VERSION)
libffi.SOURCE_PATH				=	libffi-$(libffi.VERSION)
libffi.CONFIGUREFLAGS			=	$(target.CONFIGUREFLAGS)
libffi.ENVIRONMENT				=	$(target.ENVIRONMENT)
# libffi.pkg-config_LIBNAME		= libffi

libffi-host.VERSION				=	$(libffi.VERSION)
libffi-host.SOURCE_PATH			=	$(libffi.SOURCE_PATH)
libffi-host.CONFIGUREFLAGS		=	$(host.CONFIGUREFLAGS)
libffi-host.ENVIRONMENT				=	$(host.ENVIRONMENT)

$(eval $(call template,libffi-host,host))

libffi.sourcebase: libffi.archive_sourcebase

# libffi.pkg-config_file
libffi.issue: libffi.cmi
	$(done)


libffi-host.sourcebase: libffi.sourcebase

libffi-host.issue: libffi-host.cmi
	$(done)
	
libffi-host.veryclean: libffi.veryclean


#---fin------------------------------------------------------------------------
