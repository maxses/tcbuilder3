#------------------------------------------------------------------------------
#
#  \brief   Openssl package recipe for tcbuilder
#
#           http://www.openssl.org/source
#           https://github.com/openssl/openssl.git
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


openssl.VERSION						=	4.0.3
openssl.ARCHIVE_FILE					=	openssl-$(openssl.VERSION).tar.gz
openssl.ARCHIVE_URL					=	https://www.openssl.org/source/$(openssl.ARCHIVE_FILE)
openssl.ENTRY_PATH					=	openssl-$(openssl.VERSION)
openssl.SOURCE_PATH					=	openssl-$(openssl.VERSION)
openssl.BOOTSTRAP_ARGS				=	dist threads -D_REENTRANT
openssl.MAKE_ARGS						=

### missing OSSL_SSIZE_MAX: no idea when that was lost. Try to recompile without
### define on complete sysroot
openssl.CONFIGUREFLAGS				=	 --prefix=$(TARGET_PREFIX) \
												zlib-dynamic shared threads \
												-D_REENTRANT \
												-DOSSL_SSIZE_MAX=INT_MAX \
												linux-armv4

openssl.ENVIRONMENT					=	$(target.ENVIRONMENT)
openssl.CFLAGS_FOR_TARGET			=-DOSSL_SSIZE_MAX=foo

$(eval $(call template,openssl-host,host))

openssl-host.VERSION					=$(openssl.VERSION)
# $(openssl.ENTRY_PATH) does not work; parameters are set for gcc
openssl-host.CONFIGUREFLAGS		=	--prefix=$(HOST_PREFIX) \
												linux-x86_64
openssl-host.ENTRY_PATH				=	$(openssl.ENTRY_PATH)
openssl-host.SOURCE_PATH			=	$(openssl.SOURCE_PATH)


openssl.openssl.custom_configure: zlib.issue
openssl.sourcebase: openssl.archive_sourcebase
openssl.sourcetree: openssl.sourcebase_patched
# openssl.preconfigure: zlib.issue
openssl-host.sourcetree: openssl.sourcetree

oopenssl.issue: openssl.cmi
	$(done)

openssl-host.issue: openssl-host.cmi
	$(done)


#---fin------------------------------------------------------------------------
