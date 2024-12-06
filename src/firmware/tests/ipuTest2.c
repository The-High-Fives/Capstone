#include "../utils.h"

int main()
{
    int ledState = 0;
    int *statePointer = &ledState;

    int x = 0;
    int y = 0;
    int rad = 300;
    int iter = 0;

    while (1)
    {
        setLED(false, 0, statePointer);
        setLED(false, 1, statePointer);
        setLED(false, 2, statePointer);
        setLED(false, 3, statePointer);

        x = 160 + 320 * ((iter >> 1) & 1);
        y = 120 + 240 * (iter & 1);

        if (checkLocationForColor(x, y, rad))
        {
            setLED(true, iter, statePointer);
        }

        iter = (iter + 1) % 4;
    }

end:
    goto end;
}