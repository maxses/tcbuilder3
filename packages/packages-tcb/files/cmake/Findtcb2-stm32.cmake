#-----------------------------------------------------------------------------
#
#
#
#-----------------------------------------------------------------------------


### This can not be implemented in the toolchain file itself because it would
### only get included for the main project and not for the submodules.
add_custom_command( OUTPUT ${PROJECT_NAME}.bin
     POST_BUILD
     # COMMAND ${CMAKE_STRIP} --strip-unneeded ${PROJECT_NAME}
     COMMAND ${CMAKE_NM} -A --size-sort ${PROJECT_NAME} > ${PROJECT_NAME}_size.list
     COMMAND ${CMAKE_NM} -A --numeric-sort ${PROJECT_NAME} > ${PROJECT_NAME}.list
     COMMAND ${CMAKE_OBJCOPY} -S -O ihex ${OBJCOPY_ARGS} ${PROJECT_NAME} ${PROJECT_NAME}.hex
     COMMAND ${CMAKE_OBJCOPY} -S --strip-unneeded --strip-debug -O binary ${PROJECT_NAME} ${PROJECT_NAME}.bin
     COMMAND ${CMAKE_OBJDUMP} -S ${PROJECT_NAME} > ${PROJECT_NAME}.dump
     DEPENDS ${PROJECT_NAME}
     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


add_custom_command( OUTPUT .gdbinit
     POST_BUILD
     COMMAND printf 'set arm abi AAPCS\\ntarget remote localhost:3333\\nmonitor reset halt\\n' > .gdbinit
     COMMAND printf 'monitor fast_load_image ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin 0x20000000 bin\\nmonitor fast_load\\n' >> .gdbinit
     COMMAND printf 'monitor reset halt\\n\\n' >> .gdbinit
     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


add_custom_target(${PROJECT_NAME}.binfiles DEPENDS ${PROJECT_NAME}.bin .gdbinit)


IF(NOT DEFINED TCB_DONE)

# ${TCB_DIR}/share/openocd/scripts/board/${MCU_BOARD}.cfg
add_custom_target(run_openocd
                  COMMAND
                     echo '--- konsole -e ${TCB_DIR}/bin/openocd -f ${TCB_DIR}/share/openocd/scripts/board/${MCU_OPENOCD_CONFIG}.cfg'
                  COMMAND
                     echo "\#/bin/bash"
                          "\\n"
                          "\\nkonsole -e ${TCB_DIR}/bin/openocd -f ${TCB_DIR}/share/openocd/scripts/board/${MCU_OPENOCD_CONFIG}.cfg &" 
                          "\\n" > run_openocd.sh
                  COMMAND
                     chmod +x ./run_openocd.sh
                  COMMAND
                     pgrep -x openocd || bash ./run_openocd.sh && echo Openocd already running
                  COMMAND
                     echo "\#/bin/bash"
                          "\\n"
                          "\\ni=0"
                          "\\nloops=4"
                          "\\nwhile [ $i -lt $loops ]; do"
                          "\\n   echo \"I: $i\""
                          "\\n   let i+=1"
                          "\\n   nc -zv -w2 localhost 3333 &> /dev/null && break;"
                          "\\n   sleep .4;"
                          "\\ndone"
                          "\\n[ $i -lt $loops ] || echo 'localhost [127.0.0.1] 3333 (?) : Could not start Openocd'>&2"
                          "\\n[ $i -lt $loops ] || exit 22"
                          "\\necho \"Openocd OK\"" > test_openocd.sh
                  COMMAND
                     chmod +x ./test_openocd.sh
                  COMMAND
                     bash ./test_openocd.sh
                  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                  COMMENT "Checking OpenOcd" VERBATIM
                  )


add_custom_target(info
                  COMMAND ${CMAKE_C_COMPILER} -v
                  COMMAND echo "MCU_BOARD: ${MCU_BOARD}"
                  COMMAND echo "MCU_REV: ${MCU_REV}"
                  COMMAND echo "MCU_REV_LONG: ${MCU_REV_LONG}"

                  COMMENT Showing some information about tool chain VERBATIM
                  )


ENDIF()

set ( TCB_DONE "done" )

#     COMMAND echo ${CMAKE_GDB_COMPILER} --command=commands.gdb
# run_openocd
# COMMAND ${CMAKE_GDB_COMPILER} --command=gdb_commands.txt
# monitor flash write_image erase vagus/vagus.bin 0x8008000 bin
# openocd -f board/${MCU_BOARD}.cfg
#            -c "program ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME} verify reset exit"
#
#         printf "\\\\nmonitor flash write_image erase ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin 0x"
#               >> gdb_commands.txt
#     COMMAND
#         ${CMAKE_OBJDUMP} ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME} -t | grep CURRENT_FLASH | cut -d' ' -f1
#              >> gdb_commands.txt

add_custom_target( ${PROJECT_NAME}.flash DEPENDS ${PROJECT_NAME}.binfiles ${PROJECT_NAME} run_openocd
     COMMAND
         echo "Project: ${PROJECT_NAME}"
     COMMAND
         echo "set arm abi AAPCS"
              "\\\\nset remotetimeout 5"
              "\\\\ntarget remote localhost:3333"
              "\\\\nmonitor reset init"
              "\\\\nmonitor echo \"###### Flashing ${PROJECT_NAME}\""
              "\\\\nmonitor set remotetimeout 5"
              "\\\\nshow remotetimeout"
               > gdb_commands.txt
     COMMAND
         printf "\\\\nmonitor flash write_image erase ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin 0x"
               >> gdb_commands.txt
     COMMAND
         ${CMAKE_OBJDUMP} ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME} -t | grep _FLASH_CURRENT | cut -d' ' -f1
              >> gdb_commands.txt
     COMMAND
         echo "\\\\nmonitor echo \"###### Done\""
              "\\\\nmonitor reset run"
              "\\\\ndetach"
              "\\\\nquit"
            >> gdb_commands.txt
     COMMAND
            ${CMAKE_GDB_COMPILER} --command=gdb_commands.txt
     COMMAND touch ${PROJECT_NAME}.flash
     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


### CMAKE_LD_FLAGS does not work...
function(adjust_linkerscript app_type)
   if( app_type STREQUAL "BOOTLOADER" )
      SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-T${LINKER_SCRIPT_BOOTLOADER}" PARENT_SCOPE)
      message( "adjust_linkerscript BOOTLOADER for ${PROJECT_NAME}, app_type, ${app_type}" )
   elseif ( app_type STREQUAL "APP_WITH_BOOTLOADER" )
      SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-T${LINKER_SCRIPT_APP_WITH_BOOTLOADER}" PARENT_SCOPE)
      message( "adjust_linkerscript APP_WITH_BOOTLOADER for ${PROJECT_NAME}" )
   else ()
      SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-T${LINKER_SCRIPT_APP_WITHOUT_BOOTLOADER}" PARENT_SCOPE)
      message( "adjust_linkerscript APP_WITHOUT_BOOTLOADER for ${PROJECT_NAME}" )
   endif()
endfunction()


#-----------------------------------------------------------------------------
