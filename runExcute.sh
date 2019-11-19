#! /bin/bash
#执行 make
mingw32-make.exe target=$1 TYPE=$2

#执行可执行文件
./$1
