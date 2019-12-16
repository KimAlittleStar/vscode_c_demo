#项目类型 属于C 还是 C++
TYPE ?= C

#此项目源文件后缀类型
PROJECTTYPE = .cpp

#您想要生成可执行文件的名字 如果外部没有赋值,那么使用obj.out
target ?= obj.out

#是否生成DEBUG选项
DEBUG ?=

#用户额外追加的编译配置选项
ARGS ?=

#系统之外的宏定义
PREDEF ?=

#C语言编译器
CC = gcc

#C++编译器
CXX = g++

#简化rm -f
RM = rm -f

#C语言配置参数
CFLAGS = -pedantic -std=c11 -Wall -o

#C++配置参数
CXXFLAGS = -g -Wall -std=c++11 -o

COMPILER = 

COMPILERFLAG = 

#条件编译使得其满足C项目 以及 C++项目
ifeq ($(TYPE),C)
	COMPILER := $(CC)
	COMPILERFLAG := $(CFLAGS)
	PROJECTTYPE = .c
else
ifeq ($(TYPE),C++)
	COMPILER := $(CXX)
	COMPILERFLAG := $(CXXFLAGS)
	PROJECTTYPE = .cpp

else
ifeq ($(TYPE),ARMC)
	COMPILER := $(CC)
	COMPILERFLAG := $(CFLAGS)
	PROJECTTYPE = .c
else
	COMPILER :=
	COMPILERFLAG := 
	PROJECTTYPE := 
endif
endif
endif

#获取当前makefile绝对路径
pes_parent_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))////

#删除路径下最后一个 / 
pes_parent_dir:=$(subst /////,,$(pes_parent_dir))

#将所有宏定义前方加入-D指令以便给编译器识别
DEF := $(foreach n,$(PREDEF),-D$(n))

#获取目录下所有子目录
AllDirs := $(shell cd $(pes_parent_dir); ls -R | grep '^\./.*:$$' | awk '{gsub(":","");print}') .

#添加成为绝对路径
AllDirs := $(foreach n,$(AllDirs),$(subst .,$(pes_parent_dir),$(n)))

#获取所有 .c/.cpp文件路径
Sources := $(foreach n,$(AllDirs) , $(wildcard $(n)/*$(PROJECTTYPE)))

#设置*.o 和 *.d 文件的存放路径
buildPath :=$(foreach n,$(Sources),$(subst $(pes_parent_dir),$(pes_parent_dir)/build,$(n)))

#处理得到*.o 后缀文件名
OBJS := $(patsubst %$(PROJECTTYPE),%.o, $(buildPath))  

#同理得到 *.d文件名
Deps := $(patsubst %$(PROJECTTYPE),%.d, $(buildPath))  

#需要用到的第三方静态库
StaticLib :=

#需要用到的第三方动态链接库
DynamicLib := 

#真实二进制文件输出路径
Bin :=$(pes_parent_dir)/$(target)

#头文件搜索路径
INCLUDE_PATH = $(foreach n,$(AllDirs) , -I$(n))
LDFLAGS = 


#指定AllLibs为终极目标 即:最新的Bin 
AllLibs:$(Bin)

#声明这个标签 des 用于观察当前的路径是否正确
.PHONY:des
des:
	@echo OBJS =  $(OBJS)
	@echo cur_makefile_path = $(pes_parent_dir)
	@echo AllDirs = $(AllDirs)
	@echo Sources = $(Sources)
	@echo Deps = $(Deps)
	@echo makefilePath =$(mkPath)
	@echo bulidPath=$(buildPath)
	@echo PREDEF = $(DEF)
	@echo DEBUG = $(DEBUG)
	@echo TYPE = $(TYPE)

#对应关系 在本makefile中以空格隔开的后缀为.c 都会为其生成一个新的.d文件
$(pes_parent_dir)/build/%.d :$(pes_parent_dir)/%$(PROJECTTYPE)
	@echo 'finding $< depending head file'
	@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi;
	@$(COMPILER) -MM $(INCLUDE_PATH) $(CPPFLAGS) $< > $@.$$$$;\
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@;\
	rm -f $@.$$$$
#	$(CXX) -MM $(INCLUDE_PATH) $(DEF) $(CPPFLAGS) $(CXXFLAGS) $< > $@; 

#对于include中的*.d文件，只要里面任意有一个文件被修改，那么就会触发此规则生成一个新的*.o文件
%.o: %.d
	@echo compile $(patsubst %.d,%$(PROJECTTYPE),$(subst build/,,$<)) 
	@$(COMPILER) -c $(patsubst %.d,%$(PROJECTTYPE),$(subst build/,,$<)) $(DEBUG) $(DEF) $(INCLUDE_PATH) $(ARGS) $(COMPILERFLAG) $@ 

include $(buildPath:$(PROJECTTYPE)=.d)

#生成文件的最终表达式
$(Bin) : $(OBJS)  
	@echo bulding....
	@$(COMPILER) $(OBJS) $(ARGS)  $(COMPILERFLAG) $(Bin)
	@echo created file: $(target)	

#删除所有编译带来的文件
.PHONY : clean  
clean:clean_out clean_build clean_bin

#删除 *.o文件
.PHONY : clean_out  
clean_out:
	    @echo 'removeing all *.o file ...'
	    @$(RM) -r $(pes_parent_dir)/build/*.o
	    @echo 'done'

#删除 build 文件夹
.PHONY : clean_build  
clean_build:
	    @echo 'removeing all build temp file ...'
	    @$(RM) -r $(pes_parent_dir)/build
	    @echo 'done'

#删除 可执行文件
.PHONY : clean_bin  
clean_bin:
	    @echo 'removeing executable file ...'
	    @$(RM) $(Bin)
	    @echo 'done'

		
#重新编译
.PHONY : rebuild
rebuild: clean_out AllLibs

#显示帮助
.PHONY : help
help:
		@echo "本makefile 一共实现了以下几种命令模式"
		@echo "AllLibs \t\t默认的命令,含义为编译当前项目并输出可执行文件 $(target)\n"
		@echo "clean \t\t清理命令,删除由makefile带来的所有文件\n"
		@echo "clean_out \t\t清理中间文件命令,删除由编译带来的所有文件 *.o\n"
		@echo "clean_build \t\t清理中间文件命令,删除编译临时文件夹 /build\n"
		@echo "clean_bin \t\t删除可执行文件 $(target)\n"
		@echo "rebuild \t\t重新编译\n"
		@echo "|----------------------------------------------|"
		@echo "内建一些逻辑,以及传参即可改变\n"
		@echo "ARGS \t\t用户自我追加的一些编译参数,例如多线程中需要加入 -lpthread 参数\n"
		@echo "TYPE \t\t用于确认当前项目是C++ 项目还是 C语言项目 (默认为C) 如果是C++ 那么自动编译*.cpp文件 ,如果是 C 那么自动编译*.c文件,暂不支持混合添加\n"
		@echo "target \t\t用户自定义生成的可执行文件名,例如windows下 生成obj.exe Linux下生成 obj.out\n"
		@echo "DEBUG \t\t一般传入 -g 表示支持单步调试,\n"
		@echo "PREDEF \t\t预先定义一些宏,在程序中起到开关裁剪的作用\n"
		@echo "Please check the console encoding format in case of garbled codes. The initial encoding format of this makefile is UTF8\n"





	
