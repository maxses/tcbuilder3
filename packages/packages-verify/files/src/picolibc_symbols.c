///---------------------------------------------------------------------------
///
/// \brief    symbols that are usually provided by picolibc spec
///
///           just define  them for some tcb tests
///
/// \author   Maximilian Seesslen <src@seesslen.net>
/// \date     <20230131> file created
///
///---------------------------------------------------------------------------


#if defined ( __cplusplus )
extern "C" {
#endif

// needed to get define to check for picolibc
#include <stdio.h>

#if defined ( _PICOLIBC__ ) || defined ( __PICOLIBC__ )
   char __data_start;
   char __data_size;
   char __data_source;

   char __bss_size;
   char __tls_base;
   char __stack;
   char __arm32_tls_tcb_offset;
   
   FILE *const stdout __attribute__((used))=NULL;
   
#endif

#if defined ( __cplusplus )
};
#endif


///---fin---------------------------------------------------------------------
