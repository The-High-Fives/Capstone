#include "../utils.h"

int main()
{
    Color c0 = {0xFFF, 0xFFF, 0xFFF};
    setColor(0, c0);
    Color c1 = {0x0, 0x0, 0x0};
    setColor(3, c1);

    drawCircle(320, 240, 50, 3);

    int change = 0;
    int r = 0;
    int g = 0;
    int b = 0;

    do
    {

        if (change == 0)
        {
            b++;
            if (b == 0x3FF)
            {
                change = 1;
            }
        }
        else if (change == 1)
        {
            b--;
            if (b == 0)
            {
                change = 2;
            }
        }
        else if (change == 2)
        {
            g++;
            if (g == 0x3FF)
            {
                change = 3;
            }
        }
        else if (change == 3)
        {
            g--;
            if (g == 0)
            {
                change = 4;
            }
        }
        else if (change == 4)
        {
            r++;
            if (g == 0x3FF)
            {
                change = 5;
            }
        }
        else if (change == 5)
        {
            r--;
            if (g == 0)
            {
                change = 0;
            }
        }

        c1.r = r;
        c1.g = g;
        c1.b = b;
        setColor(3, c1);
    } while (1);

    return 0;
}