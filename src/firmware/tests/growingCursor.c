#include "../utils.h"

#define CIRCLE_RADIUS 25
#define CURSOR_RADIUS 10

int main()
{
    drawRect(0, 0, 640, 480, 0);

    int milliseconds = 0;
    int seconds = 0;
    int cycles = 0;
    int dt = 0;
    int loc;
    int rev_x;
    int x;
    int y;
    int sh1;
    int sh2;
    int sh3;
    int prev_x = 0;
    int prev_y = 0;
    int rect_x;
    int rect_y;
    int rect_size;
    int radius = CIRCLE_RADIUS;
    bool valid;
    bool present;

    while (1)
    {
        dt = getTimerValue();
        cycles += dt;

        if (cycles >= 50000)
        {
            milliseconds++;
            cycles = 0;
        }

        seconds = milliseconds % 1000;

        radius = CURSOR_RADIUS + seconds;

        loc = getCursorLocation();
        sh1 = loc >> 1;
        sh2 = loc >> 2;
        sh3 = loc >> 12;

        present = sh1 & 1;
        valid = loc & 1;

        rect_x = prev_x - CURSOR_RADIUS + 5;
        rect_y = prev_y - CURSOR_RADIUS + 5;
        rect_size = CURSOR_RADIUS * 2;

        rev_x = sh2 & 0x3FF;
        x = 640 - rev_x;
        y = sh3 & 0x1FF;

        if (present && valid)
        {
            prev_x = x;
            prev_y = y;

            drawRect(rect_x, rect_y, rect_size, rect_size, 0);
            drawCircle(x, y, 20, 3);
        }
    }
}