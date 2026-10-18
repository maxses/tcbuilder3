///---------------------------------------------------------------------------
///
/// \brief    simple hello world test application for tcbuilder test
///
///           Test usage of libc/libm.
///
/// \author	Maximilian Seesslen <src@seesslen.net>
/// \date     <20130403> file created
///
///---------------------------------------------------------------------------


#include <stdio.h>
#include <stdint.h>
#include <sys/stat.h>
#include <string.h>        // memset()

#if defined ( __cplusplus )
extern "C" {
#endif

#if 0
   char __data_start;
   char __data_size;
   char __data_source;

   char __bss_size;
   char __tls_base;
   char __stack;
   char __arm32_tls_tcb_offset;
#endif

#if defined ( __cplusplus )
};
#endif

int main ( int argc, const char* argv[] )
{
   char buffer [100];
   int cx;
   float f1=1.234;
   int addr;
   
   memset(buffer, 0, 100);

   cx = snprintf ( buffer, 100, "The half of %d is %d", 60, 60/2 );
#if 0

   snprintf ( buffer+cx, 100-cx, ", and the half of that is %d.", 60/2/2 );

   // Compiles for arm-none-eabi. No idea what actually happens.
   puts (buffer);

   // Now some float stuff
   snprintf ( buffer+cx, 100-cx, ", and the half of that is %g.", f1/2 );
   puts (buffer);
#endif
  
   // Reference function "memset", an builtin
   //snprintf ( buffer, 100-cx, "The address of 'memset': %d", (int)&memset );
   addr=(int)&memset;
   
   //va_list list;
   //vsnprintf ( buffer, 100-cx, "Format", list );

   return 0;
}


///---fin---------------------------------------------------------------------
