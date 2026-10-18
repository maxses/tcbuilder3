#------------------------------------------------------------------------------
#
# \brief    handles log output for tcbuilder
#
#           colored.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


LOG_TARGET_WIDTH     = 30
LOG_MESSAGE_WIDTH    = 64
TC_MAGENTA           = \\e[36m
PAD_TARGET           = _______________________________________________________
PAD_MESSAGE1         = "......................................................."
PAD_MESSAGE          = "$(PAD_MESSAGE1)........................................."
PRINT                 = flock /tmp/tcbLogLock printf
# PRINT                 := $(PWD)/bin/sprint.sh

TC_NRM               ="\\e[37m"
TC_TRK               ="\\e[36m"
TC_RED               ="\\e[31m"
TC_ORG               ="\\e[38;5;214m"

LOG_TARGET_TEXT         ="$(TC_TRK)[%-$(LOG_TARGET_WIDTH).$(LOG_TARGET_WIDTH)s]$(TC_NRM)"
LOG_MESSAGE_TEXT        ="\\e[26m%-$(LOG_MESSAGE_WIDTH).$(LOG_MESSAGE_WIDTH)s"

LOG_ERROR_TARGET_TEXT   ="$(TC_RED)[%-$(LOG_TARGET_WIDTH).$(LOG_TARGET_WIDTH)s]$(TC_NRM)"
LOG_WARNING_TARGET_TEXT   ="$(TC_ORG)[%-$(LOG_TARGET_WIDTH).$(LOG_TARGET_WIDTH)s]$(TC_NRM)"

START                :=$(shell date +%s)

define lHint
   @let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
            $(PRINT) "[$$c] $(LOG_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
            "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)"
endef

define lError
   @let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
            $(PRINT) "[$$c] $(LOG_ERROR_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
            "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)"
endef

define lfHint
   @let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
            $(PRINT) "[$$c] $(LOG_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
            "$$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)"
endef


define lsHint
   ( \
      let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
      $(PRINT) "[$$c] $(LOG_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
               "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)" \
   )
endef

define lsWarn
   ( \
      let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
      $(PRINT) "[$$c] $(LOG_WARNING_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
               "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)" \
   )
endef

define lsErrorExit
   ( \
      let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
      $(PRINT) "[$$c] $(LOG_ERROR_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
            "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)";\
        exit 22; \
    )
endef

define lsError
   ( \
      let p=$$(date +%s)-$(START)||p=0; c=$$(date -u -d @$$p +%T); \
      $(PRINT) "[$$c] $(LOG_ERROR_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
      "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)";\
   )
endef


define dumpAndFail
        ( \
            $(PRINT) "$(LOG_ERROR_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
                    "$@$(PAD_TARGET)" "$1$(PAD_MESSAGE)";\
            $(PRINT) "$(LOG_ERROR_TARGET_TEXT) $(LOG_MESSAGE_TEXT) \n" \
                    "$@$(PAD_TARGET)" "This is the tail of the last log:$(PAD_MESSAGE)";\
            $(PRINT) "\e[33m($2)\e[37m\n"; \
            tail -n16 "$2"; \
            false \
        )
endef


#---fin------------------------------------------------------------------------
