#include "../utils.h"

#define CIRCLE_RADIUS 50

int main()
{
    int milliseconds = 0;
    int time = 0;
    int dt = 0;

    int hold_time = 1000;

    int x = 320;
    int y = 240;
    int color = 3;
    int windupCircleRadius = 0;

    drawRect(0, 0, 640, 480, 0);

    while (1)
    {
        dt = getTimerValue();
        time += dt;
        if (time >= 50000)
        {
            milliseconds += 1;
            time = 0;
        }

        windupCircleRadius = CIRCLE_RADIUS + (hold_time - milliseconds) / 10;

        drawRect(0, 0, 640, 480, 0);
        drawCircle(x, y, windupCircleRadius, color);
        drawCircle(x, y, windupCircleRadius - 5, 0);
        drawCircle(x, y, CIRCLE_RADIUS, color);

        milliseconds = milliseconds % hold_time;

        for (int i = 0; i < 10000; i++)
        {
        }
    }
}