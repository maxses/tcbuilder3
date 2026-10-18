///---------------------------------------------------------------------------
///
/// \brief    simple hello world test application for tcbuilder test
///
///           Test usage of libstdc++.
///
/// \author   Maximilian Seesslen <src@seesslen.net>
/// \date     <20130403> file created
///
///---------------------------------------------------------------------------


#define GCC_VERSION (__GNUC__ * 10000 \
                     + __GNUC_MINOR__ * 100 \
                     + __GNUC_PATCHLEVEL__)

// Test for GCC != 6.1.0
// Stdc++ librarie does not work...
// get_locale_mutex():   undefined reference to `__sync_synchronize'
//#if ! GCC_VERSION == 060100
#if __linux__

   #include <iostream>

#endif

#include <string>
#include <vector>
#include <stdio.h>


// using namespace std;

class CClass
{
   public:
      CClass &operator <<(const char *)
      {
         return(*this);
      }
};


int main ()
{

   // char buffer [100];
   // int cx;
   float f1=1.234;
   CClass cout;
    //std::string myString;

    #ifdef __linux__
      std::cout << "COUT";
    #endif

    cout << "Own class";
    //myString += "String class";

      // Only available in c++11
         // Create a vector containing integers
   #if __linux__

         std::vector<int> v = {7, 5, 16, 8};

         // Add two more integers to vector
         v.push_back(25);
         v.push_back(13);

         // Iterate and print values of vector
         for(int n : v) {
            std::cout << n << '\n';
	    ;
         }
      #endif

   printf("Printf Float: %f\n", f1);


   return 0;
}


///---fin---------------------------------------------------------------------
