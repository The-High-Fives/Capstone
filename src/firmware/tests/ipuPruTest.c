#include "../utils.h"

int main()
{
    int *x;
    int *y;

    while (1)
    {
        drawRect(0, 0, 640, 480, 0);
        getCursorLocation(x, y);
        drawCircle(*x, *y, 20, 3);
    }

end:
    goto end;
    return 0;
}