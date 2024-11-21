#include "../utils.h"

int main()
{
    Color c1 = {0, 0, 0};
    Color c2 = {0x3FF, 0, 0};
    Color c3 = {0, 0, 0x3FF};
    Color c4 = {0x3FF, 0x3FF, 0x3FF};

    setColor(0, c1);
    setColor(1, c2);
    setColor(2, c3);
    setColor(3, c4);

    int iter = 0;
    do
    {
        iter = (iter + 1) % 4;

        if (iter == 0)
        {
            c1.r = (c1.r + 1) % 0x3FF;
            c1.g = (c1.g + 1) % 0x3FF;
            c1.b = (c1.b + 1) % 0x3FF;
            setColor(iter, c1);
        }
        else if (iter == 1)
        {
            c2.r = (c2.r + 0x3FE) % 0x3FF;
            setColor(iter, c2);
        }
        else if (iter == 2)
        {
            c3.b = (c3.b + 0x3FE) % 0x3FF;
            setColor(iter, c3);
        }
        else if (iter == 3)
        {
            c4.r = (c1.r + 0x3FE) % 0x3FF;
            c4.g = (c1.g + 0x3FE) % 0x3FF;
            c4.b = (c1.b + 0x3FE) % 0x3FF;
            setColor(iter, c4);
        }

        setColor(0, (Color){0, 0, 0});
        drawCircle(80, 80, 10, 1);
        drawRect(80, 80, 10, 10, 2);
        drawSprite(80, 80, 10, 0, 3);
    } while (1);
}