#include "plugin.h"

double subPower(int under, int uper)
{
    if (uper == 0)
    {
        return 1;
    }
    else if (uper < 0)
    {
        return 1.0 / subPower(under, -uper);
    }
    else
    {
        if (uper == 1)
            return under;
        else if (uper & 0x1)
            return subPower(under * under, uper >> 1) * under;
        else
            return subPower(under * under, uper >> 1);
    }
}

void power(int under, int uper)
{
    printf("the %d ^ %d = %lf\n", under, uper, subPower(under, uper));
}
