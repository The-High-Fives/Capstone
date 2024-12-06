#include "../utils.h"

int main()
{
    int i, iter = 0;
    do
    {
        iter = (iter + 1) & 31;

        int x = 80 + (iter & 3) * 80;
        int y = 80 + (iter & 12) * 20;

        if (iter == 16 || iter == 0)
        {
            drawRect(0, 0, 0x3FF, 0x1FF, iter == 16 ? 3 : 0);
        }

        if (iter < 16)
        {
            drawCircle(x, y, 10 + iter, 1);
        }
        else
        {
            drawRect(x, y, 25 + iter, 25 + iter, 2);
        }

        for (i = 0; i < 10000000; i++)
        {
        }

    } while (1);

end:
    goto end;
}