#include "../utils.h"

int main()
{
    int i, iter = 0;
    do
    {
        iter = (iter + 1) & 7;

        int x = 80 + (iter & 1) * 160;
        int y = 80 + (iter & 2) * 80;

        if (iter == 4 || iter == 0)
        {
            drawRect(0, 0, 640, 480, 0);
        }

        if (iter & 4)
        {
            drawCircle(x, y, 40 + iter * 10, 1);
        }
        else
        {
            drawRect(x, y, 50 + iter * 10, 50 + iter * 10, 2);
        }

        for (i = 0; i < 100000; i++)
        {
        }

    } while (1);

end:
    goto end;
}