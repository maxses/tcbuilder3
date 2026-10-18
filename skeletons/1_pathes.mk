#------------------------------------------------------------------------------
#
# \brief    default pathes
#
#           This file is named 1_pathes.mk to get loaded before any other
#           script. "vpath" needs variables to be already set.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


#--- That should be set in config file
WORKPLACE                       ?=      $(HOME)/obj/tcbuilder3-$(RELEASE)
DOWNLOADS_PATH                  ?=      $(HOME)/obj/tcbuilder3-downloads

### We have to tag "$(TCB_TARGET_PLATFORM)" to build directories (done, log etc).
### $(TARGET) is unknown yet but the pathes are used as "vpath"-es already.
### No files are found, everything gets rebuild
OPWD                            :=      $(shell pwd)
SOURCE_PATH                     =      $(WORKPLACE)/source
BUILD_PATH                      =      $(WORKPLACE)/build-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)
ROOTFS_PATH                     =      $(WORKPLACE)/rootfs-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)
GENERIC_DONE_PATH               =      $(WORKPLACE)/done
DONE_PATH                       =      $(WORKPLACE)/done-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)
LOG_PATH                        =      $(WORKPLACE)/log-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)
GENERIC_LOG_PATH                =      $(WORKPLACE)/log
OPT_PATH                        =      /opt/tcb-$(RELEASE)$(TCB_TAG)

INSTALL_IS_PREFIX					 = no

ifneq ($(INSTALL_IS_PREFIX),yes)

	INSTALLROOT_HOST                =      $(ROOTFS_PATH)$(OPT_PATH)
	INSTALLROOT_TARGET              =      $(ROOTFS_PATH)$(OPT_PATH)/$(TARGET)-$(TCB_TARGET_PLATFORM)
	SYSROOT_HOST                    =      $(ROOTFS_PATH)$(OPT_PATH)
	SYSROOT_TARGET                  =      $(ROOTFS_PATH)$(OPT_PATH)/$(TARGET)-$(TCB_TARGET_PLATFORM)

	HOST_PREFIX                =/usr
   HOST_USR_PREFIX                =/usr
	HOST_NONUSR_PREFIX         =

	TARGET_PREFIX              =/usr
   TARGET_USR_PREFIX              =/usr
	TARGET_NONUSR_PREFIX       =

else

	INSTALLROOT_HOST                =      /
	INSTALLROOT_TARGET              =      /
	SYSROOT_HOST                    =      /
	SYSROOT_TARGET                  =      /

	HOST_PREFIX                =$(ROOTFS_PATH)$(OPT_PATH)/usr
   HOST_USR_PREFIX            =$(ROOTFS_PATH)$(OPT_PATH)/usr
	HOST_NONUSR_PREFIX         =$(ROOTFS_PATH)$(OPT_PATH)

	TARGET_PREFIX              =$(ROOTFS_PATH)$(OPT_PATH)/$(TARGET)-$(TCB_TARGET_PLATFORM)/usr
   TARGET_USR_PREFIX          =$(ROOTFS_PATH)$(OPT_PATH)/$(TARGET)-$(TCB_TARGET_PLATFORM)/usr
	TARGET_NONUSR_PREFIX       =$(ROOTFS_PATH)$(OPT_PATH)/$(TARGET)-$(TCB_TARGET_PLATFORM)

endif

NFS_PATH                        =   /srv/nfs

S                                =	$(SOURCE_PATH)/$($*.SOURCE_PATH)
D                                =	$(SYSROOT_TARGET)
B                                =	$(BUILD_PATH)/$*-$($*.VERSION)

CROSSTOOLS_BIN_PREFIX         =$(HOST_PREFIX)/bin/$(TARGET)
HOSTTOOLS_BIN_PREFIX          =$(HOST_PREFIX)/bin
TARGET_BIN_PREFIX             =$(TARGET_PREFIX)/bin

CROSSTOOLS_BIN_PATH           =$(SYSROOT_HOST)$(CROSSTOOLS_BIN_PREFIX)
HOSTTOOLS_BIN_PATH            =$(SYSROOT_HOST)$(HOSTTOOLS_BIN_PREFIX)
TARGET_BIN_PATH               =$(SYSROOT_TARGET)$(TARGET_BIN_PREFIX)

HBP                           =$(HOSTTOOLS_BIN_PATH)
TBP                           =$(TARGET_BIN_PATH)
CBP                           =$(CROSSTOOLS_BIN_PATH)

HOST_PATH                     =$(SYSROOT_HOST)$(HOST_PREFIX)
HOST_NONUSR_PATH              =$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX)
# $(OPT_PATH)/$(TARGET)
TARGET_PATH                   =$(SYSROOT_TARGET)$(TARGET_PREFIX)
TARGET_NONUSR_PATH            =$(SYSROOT_TARGET)$(TARGET_NONUSR_PREFIX)


#---fin------------------------------------------------------------------------
