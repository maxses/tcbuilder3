#------------------------------------------------------------------------------
#
#  \brief   RSync recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


rsync.VERSION                   = 3.5.1
rsync.ARCHIVE_FILE              = rsync-$(rsync.VERSION).tar.gz
rsync.ARCHIVE_URL               = https://download.samba.org/pub/rsync/src//$(rsync.ARCHIVE_FILE)
rsync.SOURCE_PATH               = rsync-$(rsync.VERSION)
rsync.SCOPE                     = local


rsync.CONFIGUREFLAGS					+=	$(host.CONFIGUREFLAGS) \
        --disable-openssl \
	--disable-xxhash \
        --disable-zstd \
    	--disable-lz4 \
	--disable-idn
    
rsync.ENVIRONMENT                 +=	$(host.ENVIRONMENT)
rsync.DESTDIR                     =	$(host.DESTDIR)


rsync.sourcebase:     rsync.archive_sourcebase
rsync.sourcetree:     rsync.sourcebase_patched

rsync.issue: rsync.cmi
	$(done)


#---fin------------------------------------------------------------------------
