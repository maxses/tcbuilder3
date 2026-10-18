#------------------------------------------------------------------------------
#
#  \brief   Dummy libc recipe for tcbuilder
#
#           Depencies have to be set manually in the platform file depending
#           on the libc that is used.
#           Example:
#           libc.issue:   $(NEWLIB)
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


libc.issue:	$(LIBC_PROVIDER)_libc.issue
	$(done)

libc_headers.issue:	$(LIBC_PROVIDER)_libc_headers.issue
	$(done)


#---fin------------------------------------------------------------------------
