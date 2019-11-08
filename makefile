#此项目源文件后缀类型
PROJECTTYPE = .c

#您想要生成可执行文件的名字 如果外部没有赋值,那么使用obj.out
target ?= obj.out

#是否生成DEBUG选项
DEBUG ?=

#系统之外的宏定义
PREDEF ?=

#获取当前makefile绝对路径
pes_parent_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))////

#删除路径下最后一个 / 
pes_parent_dir:=$(subst /////,,$(pes_parent_dir))

#获得mkfile 的实际路径  测试使用,  没有实际用到 可删除
mkPath:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))////
mkPath:=$(subst /////,,$(mkPath))

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

#C语言编译器
CC = gcc

#C++编译器
CXX = g++

#简化rm -f
RM = rm -f

#C语言配置参数
CFLAGS = -g  -pedantic -std=c11 -Wall -o

#C++配置参数
CXXFLAGS = -g -Wall -std=c11 

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

#对应关系 在本makefile中以空格隔开的后缀为.c 都会为其生成一个新的.d文件
#$(pes_parent_dir)/build/%.d :$(pes_parent_dir)/%.c  
#	   @echo 'finding $< depending head file'
#	   @if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi;
#	   @$(CC) -MT"$(<:.c=.o) $@" -MM $(INCLUDE_PATH) $(CPPFLAGS) $< > $@


#对应关系 在本makefile中以空格隔开的后缀为.c 都会为其生成一个新的.d文件
$(pes_parent_dir)/build/%.d :$(pes_parent_dir)/%.c
	@echo 'finding $< depending head file'
	@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi;
	@set -e; rm -f $@; \
	$(CC) -MM $(INCLUDE_PATH) $(DEF) $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$


#对于include中的*.d文件，只要里面任意有一个文件被修改，那么就会触发此规则生成一个新的*.o文件
%.o: %.d
	@echo compile $(patsubst %.d,%.c,$(subst build/,,$<)) 
	@$(CC) -c $(patsubst %.d,%.c,$(subst build/,,$<)) $(DEBUG) $(DEF) $(INCLUDE_PATH) $(CFLAGS) $@ 



$(Bin) : $(OBJS)  
	@echo bulding....
	@$(CC) $(OBJS)  $(CFLAGS) $(Bin)
	@echo created file: $(target)	

.PHONY : clean  
clean:   
	    @echo '清理所有文件ing...'
	    @$(RM) -r $(pes_parent_dir)/build/
	    @echo '清理可执行文件ing...'
	    @$(RM) $(Bin)
	    @echo 'done'

.PHONY : cleanO
cleanO:
	    @echo '清理Obj && Dep'
	    @$(RM) -r $(pes_parent_dir)/build
	    @echo 'done'
#main.out: $(OBJ)
#	cc -o main.out $(OBJ)

include $(buildPath:.c=.d)

	
