/*----------------------------------------------------------------------------

   \brief   linker script file for stm32f4 controller

            This version has to be used when application is running in ram.

   \author  Maximilian Seesslen <src@seesslen.net>
   \date    <20130403> file created

----------------------------------------------------------------------------*/


/* Entry Point */
ENTRY(Reset_Handler)

/* 192K=0x30000, 128K=0x20000 112K=0x1c000*/

/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size =  0x2000;      /* required amount of heap  */
_Min_Stack_Size = 0x2000; /* required amount of stack */
FLASH_PAGE_SIZE = 0x400;

/* Specify the memory areas */
MEMORY
{
  FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 128K
  /*
  CCMRAM (xrw)    : ORIGIN = 0x10000000, LENGTH = 64K
  MEMORY_B1 (rx)  : ORIGIN = 0x60000000, LENGTH = 0K
  */
}

/* Highest address of the user mode stack */
/* [mase]: everything higher than 0x20020000 does not work */
_estack = 0x20020000;    /* end of 128K RAM on AHB bus*/
_sflash = ORIGIN(FLASH);
_eflash = ORIGIN(FLASH) + LENGTH(FLASH);

/* Define output sections */
SECTIONS
{
  /* The startup code goes first into RAM */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >RAM

  /* The program code and other data goes into RAM */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
	*(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >RAM


   .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >RAM
    .ARM : {
    __exidx_start = .;
      *(.ARM.exidx*)
      __exidx_end = .;
    } >RAM

  .preinit_array     :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(SORT(.preinit_array.*)))
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >RAM
  .init_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >RAM
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array*))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >RAM

  /* used by the startup to initialize data */
  . = ALIGN(4);
  /* _sidata = .;*/

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data : AT ( _sidata )
  {
    . = ALIGN(4);
    _sidata = .;
    _sdata = _sidata;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.dynamic)
    /**(.got*)*/          /* i dont know */
    *(.got.plt)
    *(.got)
    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM

  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss secion */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  /* User_heap_stack section, used to check that there is enough RAM left */
  ._user_heap_stack :
  {
    . = ALIGN(4);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    PROVIDE ( __end__ = . );
    heap_low = .; /* for _sbrk */
    . = . + _Min_Heap_Size;
    heap_top = .; /* for _sbrk */
    . = . + _Min_Stack_Size;
    stack_top = .; /* for startup.s */
    . = ALIGN(4);
  } >RAM

  .user_flash :
  {
    . = ALIGN( FLASH_PAGE_SIZE );
    PROVIDE_HIDDEN (__start_user_flash = .);
  } >FLASH

  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libstdc++.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
