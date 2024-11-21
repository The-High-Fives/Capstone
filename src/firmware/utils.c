#pragma once

#include "defs.h"
#include "utils.h"

void setColor(color_t addr, Color color)
{
    int *memSet;

    memSet = (int *)COLOR_ADDR;
    memSet += (addr & 3) * 4;

    *memSet = ((color.r & 0x3FF) << 20) | ((color.g & 0x3FF) << 10) | (color.b & 0x3FF);
}

void drawRect(int x, int y, int width, int height, color_t color)
{
    int *memSet;

    memSet = (int *)DRAW_LOCATION_ADDR;
    *memSet = ((x & 0x3FF) << 9) | (y & 0x1FF);

    memSet = (int *)DRAW_CONTROL_ADDR;
    *memSet = (1 << 23) | (0 << 21) | ((color & 3) << 19) | ((width & 0x3FF) << 9) | (height & 0x1FF);
}

void drawCircle(int x, int y, int radius, color_t color)
{
    int *memSet;

    memSet = (int *)DRAW_LOCATION_ADDR;
    *memSet = ((x & 0x3FF) << 9) | (y & 0x1FF);

    memSet = (int *)DRAW_CONTROL_ADDR;
    *memSet = (1 << 23) | (1 << 21) | ((color & 3) << 19) | (radius & 0x7FFFF);
}

void drawSprite(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;

    memSet = (int *)DRAW_LOCATION_ADDR;
    *memSet = ((x & 0x3FF) << 9) | (y & 0x1FF);

    memSet = (int *)SPRITE_ADDR;
    *memSet = addr;

    memSet = (int *)DRAW_CONTROL_ADDR;
    *memSet = (1 << 23) | (2 << 21) | ((color & 3) << 19) | (scale & 0x7FFFF);
}

void drawLetter(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;

    memSet = (int *)DRAW_LOCATION_ADDR;
    *memSet = ((x & 0x3FF) << 9) | (y & 0x1FF);

    memSet = (int *)SPRITE_ADDR;
    *memSet = addr;

    memSet = (int *)DRAW_CONTROL_ADDR;
    *memSet = (1 << 23) | (3 << 21) | ((color & 3) << 19) | (scale & 0x7FFFF);
}

void setLED(bool value, int led)
{
    int *memSet;
    bool val = value & 1;

    memSet = (int *)LED_ADDR;

    if (val)
    {
        *memSet |= 1 << led;
    }
    else
    {
        *memSet &= ~(1 << led);
    }
}

int getTimerValue()
{
    int *memSet;

    memSet = (int *)TIMER_ADDR;
    return *memSet;
}

bool checkLocationForColor(int x, int y, int radius)
{
    int *memSet;

    memSet = (int *)DETECT_LOCATION_ADDR;
    *memSet = ((x & 0x3FF) << 19) | ((y & 0x1FF) << 10) | (radius & 0x3FF);

    memSet = (int *)COLOR_LOCATED_ADDR;
    return (*memSet) & 1;
}

char getSPART()
{
    char *memSet;

    memSet = (char *)SPART_READ_ADDR;
    return *memSet;
}

void setSPART(char value)
{
    int *memSet;

    memSet = (int *)SPART_WRITE_ADDR;
    *memSet = value;
}

void getIO(int *timer, char *SPART)
{
    *timer = getTimerValue();
    *SPART = getSPART();
}