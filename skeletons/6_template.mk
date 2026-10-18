#------------------------------------------------------------------------------
#
# \brief    Let packages use the own ld
#
#           Necessarry to use own created host libraries instead of liobaries 
#           of the host system
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20240516> file created
#
#------------------------------------------------------------------------------


define template

   # The double "$$" is very importatnt or parts like $(*.CFLAGS) will be useless
   $1.ENVIRONMENT          += $$($2.ENVIRONMENT)
   $1.CONFIGUREFLAGS       += $$($2.CONFIGUREFLAGS)
   $1.DESTDIR              = $$($2.DESTDIR)
   $1.CMAKE_ARGS           += $$($2.CMAKE_ARGS)
   $1.MESONFLAGS           += $$($2.MESONFLAGS)
endef


#---fin------------------------------------------------------------------------
