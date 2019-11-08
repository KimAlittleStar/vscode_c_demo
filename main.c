#include "Exfunction.h"
//this is a new comment:
int main(void)
{
    char commend[500];
    for (;;)
    {
        //scanf("%s",commend);
        fgets(commend, 499, stdin);
        //	printf("reciver :%s--!\n",commend);
        ExternFunc_excute(commend);
    }
}
