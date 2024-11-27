#include "../utils.h"

int main()
{
    int *x;
    int *y;

    while (1)
    {
        getCursorLocation(x, y);
        if (*x > 320)
        {
            setLED(true, 1);
        }
        else
        {
            setLED(false, 1);
        }

        if (*y > 240)
        {
            setLED(true, 2);
        }
        else
        {
            setLED(false, 2);
        }
    }

end:
    goto end;
}