#include "../utils.h"

int main()
{
    int x = 0;
    int y = 0;
    int rad = 300;
    int iter = 0;

    while (1)
    {
        setLED(false, 0);
        setLED(false, 1);
        setLED(false, 2);
        setLED(false, 3);

        x = 160 + 320 * ((iter >> 1) & 1);
        y = 120 + 240 * (iter & 1);

        if (checkLocationForColor(x, y, rad))
        {
            setLED(true, iter);
        }

        iter = (iter + 1) % 4;
    }

end:
    goto end;
}