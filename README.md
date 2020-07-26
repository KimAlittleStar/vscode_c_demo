# 一个在vscode上开发的测试例程
-------
## 更新说明:
更新VScode的配置文件,可以Debug CPP项目与C项目,两者互不相通,CPP项目只能识别\*.cpp文件,C项目识别 \*.c文件.
如果有同名文件但后缀不同时,需要先clean在build.
本套配置可以使用在任何一个纯c或者纯cpp项目.makefile会将所有的cpp或者c文件一一编译后生成文件.
-------

##   文件夹说明

###   .git
      git的仓库文件，你所有提交了的历史版本都在这个文件夹里
###   .vscode
      vscode 的配置文件夹，所有有关VS code的项目相关配置都会在这个文件夹中；
      并且后期你可以将这个.vscode 文件夹移动到你想要编辑的项目下，使用vscode打开
      你的项目文件夹，那么就可以直接使用vscode进行编译调试开发了哦~
###   build
      此文件夹不在git仓库显示，但是你在生成文件后会出现在你的文件夹中，你可以随时删除它，因为他是
      自动生成的
###   .gitignore
      此文件与git功能相关如不使用git 可以删除
##   例程功能说明
        在 Exfunction.c文件中 有一个静态函数列表 const CALLFUNCTIONTABLE functable[]
        你只需要在此列表中加入你想要调用执行的函数，那么你就可以直接在控制台输入你想要的函数名称，即可调用函数；
        加入的格式为：
        EXPOTRFUNC(<函数别名>,<真正的函数名称>,<传参格式化字符串>,<函数解释>)
        例如 函数原型为： void show_add_function(int a,int b);
        加入列表：
        EXPOTRFUNC(add,show_add_function,%d %d,将两个数相加)
        编译后在窗口 输入： add 3 4 ；类似调用了show_add_function（3,4);
        目前只支持 char short int 


