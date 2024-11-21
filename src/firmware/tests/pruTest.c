#include "../utils.h"

int main()
{
    drawCircle(80, 80, 10, 1);
    drawRect(80, 80, 10, 10, 2);
    int iter = 0;
    do
    {
        iter = (iter + 1) & 7;

        int x = 80 + (iter & 1) * 160;
        int y = 80 + (iter & 2) * 80;

        if (iter & 4)
        {
            drawCircle(x, y, 10, 1);
        }
        else
        {
            drawRect(x, y, 10, 10, 2);
        }
    } while (1);
}