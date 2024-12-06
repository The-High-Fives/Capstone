#include "../utils.h"

int main()
{
    int ledState = 0;
    int *statePointer = &ledState;

    int *x = -1;
    int *y = -1;

    while (1)
    {
        getCursorLocation(x, y);

        if (*x == -1 || *y == -1)
        {
            continue;
        }

        if (*x > 320)
        {
            setLED(true, 1, statePointer);
        }
        else
        {
            setLED(false, 1, statePointer);
        }

        if (*y > 240)
        {
            setLED(true, 2, statePointer);
        }
        else
        {
            setLED(false, 2, statePointer);
        }
    }

end:
    goto end;
}