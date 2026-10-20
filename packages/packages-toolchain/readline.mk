#------------------------------------------------------------------------------
#
#  \brief   Readline package recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20251227> file created
#
#------------------------------------------------------------------------------


readline.VERSION         = readline-8.3
readline.SCM_TOOL        = git
readline.SCM_URL         = https://https.git.savannah.gnu.org/git/readline.git
readline.SOURCE_PATH     = readline-mainline

$(eval $(call Package,readline))
$(eval $(call template,readline,host))
$(eval $(call useOwnLdNative, readline))

# There is no termcap at the moment
# readline.CONFIGUREFLAGS  += \
#                            --with-shared-termcap-library

readline.sourcebase: readline.scm_sourcebase
readline.sourcetree: readline.sourcebase_patched
# Readline needs "-ltermcap"
readline.cmi_configure: ncurses-host.issue

readline.install: readline.cmi

readline.issue: readline.skeleton
	$(done)


#---fin------------------------------------------------------------------------
