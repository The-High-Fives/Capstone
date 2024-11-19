#pragma once

#include "defs.h"
#include "utils.h"

void drawCircle(int x, int y, int radius, color_t color)
{
    int *memSet;

    memSet = (int *)0x4100;
    *memSet = (x << 9) | (y & 0x1FF);

    memSet = (int *)0x4104;
    *memSet = (1 << 23) | (1 << 21) | ((color & 3) << 19) | (radius & 0x7FFFF);
}

void drawRect(int x, int y, int width, int height, color_t color)
{
    int *memSet;

    memSet = (int *)0x4100;
    *memSet = (x << 9) | (y & 0x1FF);

    memSet = (int *)0x4104;
    *memSet = (1 << 23) | (0 << 21) | ((color & 3) << 19) | ((width & 0x3FF) << 9) | (height & 0x1FF);
}

void drawSprite(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;

    memSet = (int *)0x4100;
    *memSet = (x << 9) | (y & 0x1FF);

    memSet = (int *)0x4104;
    *memSet = (1 << 23) | (2 << 21) | ((color & 3) << 19) | (scale & 0x7FFFF);
}

void drawLetter(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;

    memSet = (int *)0x4100;
    *memSet = (x << 9) | (y & 0x1FF);

    memSet = (int *)0x4108;
    *memSet = addr;

    memSet = (int *)0x4104;
    *memSet = (1 << 23) | (3 << 21) | ((color & 3) << 19) | (scale & 0x7FFFF);
}

void setColor(color_t addr, Color color)
{
    int *memSet;

    memSet = (int *)0x4000;
    memSet += addr * 4;

    *memSet = ((color.r & 0x3FF) << 20) | ((color.g & 0x3FF) << 10) | (color.b & 0x3FF);
}