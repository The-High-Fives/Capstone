#include "../utils.h"

int main()
{
    Color c0 = {0x7FF, 0x7FF, 0x7FF};
    setColor(0, c0);
    Color c1 = {0x0, 0x0, 0x0};
    Color c2 = {0xFFF, 0xFFF, 0xFFF};
    setColor(3, c1);

    drawCircle(320, 240, 50, 3);

    int color = 0;

    do
    {
        if (color)
        {
            setColor(3, c1);
            color = 0;
        }
        else
        {
            setColor(3, c2);
            color = 1;
        }
    } while (1);

    return 0;
}