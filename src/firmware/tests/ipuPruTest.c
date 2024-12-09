#include "../utils.h"

int main()
{
    int loc;
    int sh1;
    int sh2;
    int sh3;

    int prev_x = 0;
    int prev_y = 0;

    int x = 0;
    int rev_x;
    int y = 0;
    int rect_x;
    int rect_y;
    bool present;
    bool valid;
    drawRect(0, 0, 640, 480, 0);
    while (1)
    {
        loc = getCursorLocation();
        sh1 = loc >> 1;
        sh2 = loc >> 2;
        sh3 = loc >> 12;

        present = sh1 & 1;
        valid = loc & 1;

        rect_x = prev_x - 24;
        rect_y = prev_y - 24;

        rev_x = sh2 & 0x3FF;
        x = 640 - rev_x;
        y = sh3 & 0x1FF;

        if (present && valid)
        {
            prev_x = x;
            prev_y = y;

            drawRect(rect_x, rect_y, 48, 48, 0);
            drawCircle(x, y, 20, 3);
        }
    }

end:
    goto end;
    return 0;
}