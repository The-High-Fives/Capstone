#include "../utils.h"

int main()
{
    int *x;
    int *y;
    int *present;
    int *valid;

    while (1)
    {
        drawRect(0, 0, 640, 480, 0);
        getCursorLocation(x, y, present, valid);
        drawCircle(*x, *y, 20, 3);
    }

end:
    goto end;
    return 0;
}