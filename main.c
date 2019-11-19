#include "Exfunction.h"
//this is a new comment:
int main(void)
{
    char commend[500];
    for (;;)
    {
        //scanf("%s",commend);
        printf("typing your command\n");
        fgets(commend, 499, stdin);
        ExternFunc_excute(commend);
    }
}

