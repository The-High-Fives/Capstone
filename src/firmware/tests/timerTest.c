#include "../utils.h"

int main()
{
    int ledState = 0;
    int *statePointer = &ledState;
    int timer = 0;
    bool LED = true;

    do
    {
        timer += getTimerValue();
        bool switchLED = timer >= 1000000;
        if (switchLED)
        {
            setLED(LED, 1, statePointer);
            LED = !LED;
            timer = 0;
        }
    } while (1);

    return 0;
}