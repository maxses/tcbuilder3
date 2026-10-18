/*----------------------------------------------------------------------------

   \brief   linker script include file for stm32 controllers

            This version has to be used when application is running in
            flash memory.

   \author  Maximilian Seesslen <src@seesslen.net>
   \date    <20130403> file created

----------------------------------------------------------------------------*/

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm",
				  "elf32-littlearm")
OUTPUT_ARCH(arm)

/* Entry Point */
ENTRY(Reset_Handler)


EXTERN(
	/*  override_Handler */
	/*  Referning to an weak symbol seems to be sufficient.  */
	XXSysTick_Handler
	malloc
)


MEMORY
{
  FLASH_TOTAL(rx) : ORIGIN = DEFINED(__flash) ? __flash : 0x08000000, LENGTH = DEFINED(__flash_size) ? __flash_size : 64K
  RAM (xrw)       : ORIGIN = DEFINED(__ram) ? __ram : 0x20000000, LENGTH = DEFINED(__ram_size) ? __ram_size : 6K
}

REGION_ALIAS("FLASH", FLASH_TOTAL);
REGION_ALIAS("FLASH_APP", FLASH_TOTAL);
REGION_ALIAS("FLASH_BL", FLASH_TOTAL);

/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size =  DEFINED(__heap_size) ? __heap_size : ( ( LENGTH(RAM) / 16 ) * 8 ) ;      /* required amount of heap  */
_Min_Stack_Size = DEFINED(__stack_size) ? __stack_size : ( ( LENGTH(RAM) / 16 ) * 2 ) ; /* required amount of stack */

_FLASH_CURRENT = ORIGIN(FLASH);
_FLASH_APP = ORIGIN(FLASH_APP);
_FLASH_BOOTLOADER = ORIGIN(FLASH_BL);

_sflash = ORIGIN(FLASH);
_eflash = ORIGIN(FLASH) + LENGTH(FLASH);
_eram = ORIGIN(RAM) + LENGTH(RAM);

/* Highest address of the user mode stack */
_estack = ORIGIN(RAM) + LENGTH(RAM) - 0x20; /* Used by libstm startup code*/


/*
heap_top = _eram - _Min_Stack_Size;
*/

/* Define output sections */
SECTIONS
{
  /* The startup code goes first into FLASH */
  .isr_vector :
  {
     /*PROVIDE ( very_start = . );*/
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH

  /* The program code and other data goes into FLASH */
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
  } >FLASH

/*
   .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
    .ARM : {
    __exidx_start = .;
      *(.ARM.exidx*)
      __exidx_end = .;
    } >FLASH
*/
  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >FLASH
  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >FLASH
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array*))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >FLASH

  /* used by the startup to initialize data */
  _sidata = .;

  /* Initialized data sections goes into RAM, load LMA copy after code */
  /*.dynamic        : { *(.dynamic) }*/
  /*.got            : { *(.got.plt) *(.got) }*/
  .data_all : AT ( _sidata )
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.dynamic)
    /**(.got*)*/          /* i dont know */
    *(.got.plt)
    *(.got)
    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM

	.tbss (NOLOAD) : {
		*(.tbss .tbss.* .gnu.linkonce.tb.*)
		*(.tcommon)
		PROVIDE( __tls_end = . );
	} >RAM AT>RAM
	/* :tls :ram */
	PROVIDE( __bss_start = ADDR(.tbss));
	PROVIDE( __tbss_size = SIZEOF(.tbss) );
	PROVIDE( __tls_size = __tls_end - __tls_base );

  .marker :
  {
     /* Bug? flash address is not increased by flash/ram copied section */
     /* We have to adjust it manually to find the end of used flash */
	  /*.  += SIZEOF(.data_all);*/
	  . = ALIGN ( __flash_page_size );
     PROVIDE (_start_user_flash = . );
  } >FLASH

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
  } >RAM

  .ebss : {
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
	 __heap_start = . ;
	 _sheap = .; /* picolibc */
	 . = . + _Min_Heap_Size;
	 __heap_end = . ;
	 _eheap = .; /* picolibc */

  } >RAM

	._user_stack :
	{
	  PROVIDE ( _user_stack = . );
	  . = ALIGN(4);
	  . = . + _Min_Stack_Size;
	} >RAM

/*
. = . + _Min_Heap_Size;
heap_top = .;
. = . + _Min_Stack_Size;
stack_top = .;
. = ALIGN(4);
*/
  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libstdc++.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

		/* .ARM.attributes 0 : { *(.ARM.attributes) }  > FLASH */

	/DISCARD/ : {
		*(.ARM.attributes)
		*(.note .note.*)
		*(.eh_frame .eh_frame.*)
		*(.ARM.extab* .gnu.linkonce.armextab.*)
		*(.ARM.exidx*)
	}

}


/*---fin--------------------------------------------------------------------*/
