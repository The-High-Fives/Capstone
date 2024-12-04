#include "../utils.h"

// WORKING!!!
int main()
{
    int ledState = 0;
    int *statePointer = &ledState;

    while (true)
    {
        int i = 0;
        int j = 0;

        for (i = 0; i < 10; i++)
        {
            setLED(true, i, &ledState);
        }

        for (j = 0; j < 1000000; j++)
        {
            j++;
        }

        for (i = 0; i < 10; i++)
        {
            setLED(false, i, &ledState);
        }

        for (j = 0; j < 1000000; j++)
        {
            j++;
        }
    }

end:
    goto end;

    return 0;
}