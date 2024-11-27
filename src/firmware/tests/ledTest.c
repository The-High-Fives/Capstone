#include "../utils.h"

int main()
{
    setLED(true, 1);
    setLED(false, 1);
    setLED(true, 2);
    setLED(false, 2);

    for (int i = 0; i < 10; i++)
    {
        setLED(true, i);
    }

    int j = 0;
    for (int i = 0; i < 5000; i++)
    {
        j++;
    }

    for (int i = 0; i < 10; i++)
    {
        setLED(false, i);
    }

end:
    goto end;

    return 0;
}