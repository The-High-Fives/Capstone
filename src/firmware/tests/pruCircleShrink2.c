#define CIRCLE_RADIUS 50

int main()
{
    int milliseconds = 0;
    int seconds = 0;
    int seconds2 = 0;
    int prevMilliseconds = -1;
    int time = 0;
    int dt = 0;

    int hold_time = 25;

    int x = 320;
    int y = 240;
    int color = 3;
    int windupCircleRadius = 0;
    int prevScaledTimeDiff = 0;

    drawRect(0, 0, 640, 480, 0);

    while (1)
    {
        dt = getTimerValue();
        time += dt;
        if (time >= 50000)
        {
            milliseconds++;
            time = 0;
        }
        if (milliseconds >= 1000)
        {
            seconds++;
            seconds2++;
            milliseconds = 0;
        }

        seconds = seconds % hold_time;

        int time_diff = hold_time - seconds;
        int scaled_time_diff = time_diff;

        windupCircleRadius = CIRCLE_RADIUS + scaled_time_diff;

        // int rect_size = windupCircleRadius * 2;

        // int rect_start_x = x - windupCircleRadius;
        // int rect_start_y = y - windupCircleRadius;

        // drawRect(rect_start_x, rect_start_y, rect_size, rect_size, 0);

        if (seconds2)
        {
            drawRect(0, 0, 640, 480, 0);
            drawCircle(x, y, windupCircleRadius, color);
            drawCircle(x, y, windupCircleRadius - 5, 0);
            drawCircle(x, y, CIRCLE_RADIUS, color);
            prevScaledTimeDiff = scaled_time_diff;
        }
    }
}