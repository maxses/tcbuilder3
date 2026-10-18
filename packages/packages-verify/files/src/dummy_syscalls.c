///---------------------------------------------------------------------------
///
/// \brief    Dummy syscalls for printf test in tcb
///
/// \author	Maximilian Seesslen <src@seesslen.net>
/// \date     <20170226> file created
///
///---------------------------------------------------------------------------



#include <stdio.h> 		// FIILE
// #include <reent.h>
#include <stdint.h>
#include <sys/stat.h>
#include <sys/types.h>		// pid_t

#ifdef __cplusplus
extern "C"
{
#endif

    //char __stack;
    //struct __file *const __iob[]={&___stdin, &___stdout, &___stderr};
    //char __data_size;
    //char __bss_size;
    //char __tls_base;
    //char __data_source;
    char __heap_start;
    char __heap_end;
    void abort() __attribute__ (( used ));
    void __aeabi_atexit();

   int _getpid ()
   {
      return(0);
   }
   void* _sbrk 	( 	intptr_t  	increment	)
   {
      return(NULL);
   }

   ssize_t _read (int fd, void * buf, size_t count)
   {
      //foo
	return(0);
   }

   ssize_t _write (int fd, const void * buf, size_t count)
   {
      //foo
	return(0);   
    }

   int _kill (pid_t pid, int sig)
   {
      while(1)
      {
         asm("nop;\n");
      }
	return(0);
   }

   void	_exit(int status ) __attribute ((noreturn, used));
   void	_exit(int status )
   {
      while(1)
      {
         asm("nop;\n");
      }
   }

   int _isatty(int file) { return 1; }

   int _lseek(int file, int ptr, int dir) { return 0; }

   int _open(const char *name, int flags, int mode) { return -1; }

   int _close(int file) { return -1; }

   int _fstat(int file, struct stat *st) {
      st->st_mode = S_IFCHR;
      return 0;
   }

   int getpid() __attribute__ (( used ));
   int getpid()
   {
      return(0);
   }

   int kill (pid_t pid, int sig) __attribute__ (( used ));
   int kill (pid_t pid, int sig)
   {
      while(1)
      {
         asm("nop;\n");
      }
   return(0);
   }

#ifdef __cplusplus
}
#endif

#if defined ( _PICOLIBC__ )
   // Its true, its c++ linkage
   //FILE * const stdout __attribute__ (( used ))=NULL;
#endif


///---fin---------------------------------------------------------------------
