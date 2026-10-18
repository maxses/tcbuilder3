///---------------------------------------------------------------------------
///
/// \brief    simple hello world test application for tcbuilder test
///
///           Test usage of libc/libm.
///
/// \author	Maximilian Seesslen <src@seesslen.net>
/// \date     <20251230> file created
///
///---------------------------------------------------------------------------


#include <stdio.h>


int main ( int argc, const char* argv[] )
{
   char buffer [100];
   snprintf ( buffer, 100, "The half of %d is %d", 60, 60/2 );
   return 0;
}


///---fin---------------------------------------------------------------------
