#include "../utils.h"

int main()
{
    int timer = 0;
    bool LED = true;

    do
    {
        timer += getTimerValue();
        bool switchLED = timer > 1000;
        if (switchLED)
        {
            setLED(LED, 1);
            LED = !LED;
            timer = 0;
        }
    } while (1);

    return 0;
}