#!/bin/bash
#------------------------------------------------------------------------------
#
# \brief    Compiles toolchains for ST microcontroller
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     20150901 File created
#
#------------------------------------------------------------------------------


set -e -u

# Show some continuously running timestamp. This can not be done in the 
# Makefile directly.
# The function is spawned but has to check if parent process died meanwhile.
logFunc()
{
   cnt=0;
   START=$(date +%s)

   while [ 1 ]; do
      let timestamp=$(date +%s)-${START} || p=0
      code=$(date -u -d @$timestamp +%T)
      flock /tmp/tcbLogLock printf "[$code]\r"
      sleep 1
      let cnt+=1
      if [ ! -e "/proc/${PARENT}" ]; then
         exit
      fi
   done
}

PARENT=$$
logFunc &
logPid=$!

unset LANG
platform=stm32
### local_optimization: caution: generic does not work here, use empty "" instead.
local_optimization=
NPROC=$(nproc)
let NPROC*=3
# export MAKEFLAGS="-j${NPROC}"
# export MAKEFLAGS="-j1"
export MAKEFLAGS="-j${NPROC}"

function end()
{
   [ -e "/usr/bin/aplay" ] && [ -d "/dev/snd" ] && [ -e "/usr/share/sounds/sound-icons/prompt.wav" ] && aplay /usr/share/sounds/sound-icons/prompt.wav
}

package=toolchain
package=release

echo "### Building '$package.issue'."
echo "### MAKEFLAGS: ${MAKEFLAGS}"

# Play a sound when finished; successfull or not
trap end 0 1 2 3 13 15 # EXIT HUP INT QUIT PIPE TERM

if [ "$#" -gt "0" ]; then
   time make TCB_TARGET_PLATFORM=$platform LOCAL_OPTIMIZATION=$local_optimization ${MAKEFLAGS} $@
else
   time make TCB_TARGET_PLATFORM=$platform LOCAL_OPTIMIZATION=$local_optimization ${MAKEFLAGS} $package.clean
   time make TCB_TARGET_PLATFORM=$platform LOCAL_OPTIMIZATION=$local_optimization ${MAKEFLAGS} $package.issue
fi

kill $logPid


#---fin------------------------------------------------------------------------
