#include "../utils.h"

#define CURSOR_RADIUS 5
#define CIRCLE_RADIUS 20
#define CIRCLE_RADIUS_SQ 400

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
    int rect_size;

    int rect2_x;
    int rect2_y;
    int rect2_size;

    bool present;
    bool valid;

    int base_circle_x = 20;
    int base_circle_y = 20;

    int circle_x_inc = 150;
    int circle_y_inc = 110;

    int circle_x = 0;
    int circle_y = 0;

    int circle_x_diff = 0;
    int circle_y_diff = 0;
    int circle_diff = 0;

    int row = 0;
    int col = 0;

    int r = 0;
    int g = 0;
    int b = 0;

    int i = 0;
    int j = 0;
    int k = 0;
    int state = 0;
    int x_inc_acc;
    int y_inc_acc;
    int x_diff_sq;
    int y_diff_sq;

    Color c0 = {0x3FF, 0x3FF, 0x3FF};
    Color c1 = {0, 0, 0};
    Color c2 = {0, 0x3FF, 0};
    Color c3 = {0x3FF, 0, 0};

    drawRect(0, 0, 640, 480, 0);
    setColor(0, c0);
    setColor(1, c1);
    setColor(2, c2);
    setColor(3, c3);

    while (1)
    {
        for (j = 0; j < 16; j++)
        {
            int c_r = j >> 2;
            int c_c = j & 3;

            int c_x_inc = 0;
            int c_y_inc = 0;

            for (k = 0; k < c_r; k++)
            {
                c_x_inc += circle_x_inc;
            }
            for (k = 0; k < c_c; k++)
            {
                c_y_inc += circle_y_inc;
            }

            int c_x = base_circle_x + c_x_inc;
            int c_y = base_circle_y + c_y_inc;

            drawCircle(c_x, c_y, 2, 2);
        }
        row = state >> 2;
        col = state & 3;

        x_inc_acc = 0;
        for (j = 0; j < row; j++)
        {
            x_inc_acc += circle_x_inc;
        }

        y_inc_acc = 0;
        for (j = 0; j < col; j++)
        {
            y_inc_acc += circle_y_inc;
        }

        circle_x = base_circle_x + x_inc_acc;
        circle_y = base_circle_y + y_inc_acc;

        loc = getCursorLocation();
        sh1 = loc >> 1;
        sh2 = loc >> 2;
        sh3 = loc >> 12;

        present = sh1 & 1;
        valid = loc & 1;

        rect_x = prev_x - CURSOR_RADIUS - 3;
        rect_y = prev_y - CURSOR_RADIUS - 3;
        rect_size = CURSOR_RADIUS + CURSOR_RADIUS + 6;

        rect2_x = circle_x - CIRCLE_RADIUS - 3;
        rect2_y = circle_y - CIRCLE_RADIUS - 3;
        rect2_size = CIRCLE_RADIUS + CURSOR_RADIUS + 6;

        rev_x = sh2 & 0x3FF;
        x = 640 - rev_x;
        y = sh3 & 0x1FF;

        circle_x_diff = circle_x - x;

        x_diff_sq = 0;
        for (j = 0; j < circle_x_diff; j++)
        {
            x_diff_sq += circle_x_diff;
        }

        circle_y_diff = circle_y - y;

        y_diff_sq = 0;
        for (j = 0; j < circle_y_diff; j++)
        {
            y_diff_sq += circle_y_diff;
        }

        circle_diff = x_diff_sq + y_diff_sq;

        if (valid)
        {
            if (i >= 500)
            {
                i = 0;

                if (b < 0x3FF)
                {
                    b++;
                }
                else
                {
                    b = 0;
                }

                Color c = {r, g, b};

                setColor(1, c);
            }
            i++;
        }

        if (valid & present)
        {

            if (circle_diff < CIRCLE_RADIUS_SQ)
            {
                drawRect(rect2_x, rect2_y, rect2_size, rect2_size, 0);

                state = (state + 1) & 15;
            }

            drawCircle(circle_x, circle_y, CIRCLE_RADIUS, 1);

            prev_x = x;
            prev_y = y;

            drawRect(rect_x, rect_y, rect_size, rect_size, 0);
            drawCircle(x, y, CURSOR_RADIUS, 3);
        }
        else if (valid)
        {
            drawCircle(circle_x, circle_y, CIRCLE_RADIUS, 1);
        }
    }

end:
    goto end;
    return 0;
}