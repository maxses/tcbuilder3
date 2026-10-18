#!/bin/bash

set -e -u

opwd=$PWD

## First, get patchelf working
#echo "$PWD/lib" > etc/ld.so.conf
#echo "$PWD/usr/lib" >> etc/ld.so.conf
#echo "$PWD/usr/lib64" >> etc/ld.so.conf
#
#./sbin/ldconfig -C etc/ld.so.cache -f etc/ld.so.conf
PATCHELF="./lib/ld-linux-x86-64.so.2 --library-path lib:usr/lib:usr/lib64 ./usr/bin/patchelf"

find usr/lib usr/bin -executable -type f | while read bin; do
    echo $bin
    type=$(file -b --mime-type $bin)
    if [ "$type" == "application/x-executable" ] || [ "$type" == "application/x-pie-executable" ]; then
        echo "   patching..."
        if [ "$bin" != "usr/bin/patchelf" ]; then
        ${PATCHELF} \
            --set-interpreter $opwd/lib/ld-linux-x86-64.so.2 \
            --set-rpath $opwd/lib64:$opwd/lib:$opwd/usr/lib64:$opwd/usr/lib \
            $bin
        fi
    fi

    if [ "$type" == "application/x-sharedlib" ]; then
        echo "   patching..."
        ${PATCHELF} \
            --set-rpath $opwd/lib64:$opwd/lib:$opwd/usr/lib64:$opwd/usr/lib \
            $bin
    fi

done

find bin usr/bin -executable -type f | while read bin; do
    echo $bin
    type=$(file -b $bin)
    if [ "$type" == "Python script, ASCII text executable" ]; then
	echo "   patching python"
	sed -i "s|#\!/.*|#\!$opwd/usr/bin/python3|" $bin
    fi
done

echo
echo "Testing GCC"
sta=0
usr/bin/arm-none-eabi/arm-none-eabi-g++ -v || sta=1

if [ "$sta" != 0 ]; then
    echo "Something is wrong"
    exit 22
else
    echo "Toolchain is working"
fi

echo -e "#include <stdio.h>\nint main(int argc, const char* argv[])\n{\n   printf(\"Hello\\\\n\");\n   return(0);\n}" > main.cpp
usr/bin/arm-none-eabi/arm-none-eabi-g++ --sysroot=$PWD/arm-none-eabi-stm32 -c main.cpp -o main.o

echo 
echo > a.s
usr/lib/arm-none-eabi/bin/as -v a.s || sta=1
./usr/bin/cmake --version || sta=1
./usr/bin/arm-none-eabi/arm-none-eabi-gdb --version || sta=1

echo

if [ "$sta" != 0 ]; then
    echo -e "\x1b[31mSomething is wrong\x1b[0m" 
    exit 22
else
    echo -e "\x1b[32mToolchain is working\x1b[0m" 
fi


echo "[$0] fin."


#---fin------------------------------------------------------------------------
