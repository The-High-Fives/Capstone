#include "../utils.h"

int main()
{
    int i, iter = 0;
    do
    {
        iter = (iter + 1) & 31;

        int x = 80 + (iter & 3) * 160;
        int y = 80 + (iter & 12) * 40;

        if (iter == 16 || iter == 0)
        {
            drawRect(0, 0, 640, 480, 0);
        }

        if (iter & 16)
        {
            drawCircle(x, y, 40 + iter * 3, 1);
        }
        else
        {
            drawRect(x, y, 50 + iter * 3, 50 + iter * 3, 2);
        }

        for (i = 0; i < 10000000; i++)
        {
        }

    } while (1);

end:
    goto end;

end:
    goto end;
}