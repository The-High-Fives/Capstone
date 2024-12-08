#include "../utils.h"

int main()
{
    while (1)
    {
        int loc = getCursorLocation();
        int sh1 = loc >> 1;
        int sh2 = loc >> 2;
        int sh3 = loc >> 12;

        bool present = sh1 & 1;
        bool valid = loc & 1;

        int rev_x = sh2 & 0x3FF;
        int y = sh3 & 0x1FF;
        int x = 640 - rev_x;

        if (present && valid) {
            drawRect(0, 0, 640, 480, 0);
            drawCircle(x, y, 20, 3);
        }
    }

end:
    goto end;
    return 0;
}