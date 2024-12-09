#pragma once

#include "utils.h"

void setColor(color_t addr, Color color)
{
    int *memSet;
    int command;

    memSet = (int *)(COLOR_ADDR + (addr & 3) * 4);

    command = ((color.r & 0x3FF) << 20) | ((color.g & 0x3FF) << 10) | (color.b & 0x3FF);
    *memSet = command;
}

void drawRect(int x, int y, int width, int height, color_t color)
{
    int *memSet;
    int command;

    memSet = (int *)DRAW_LOCATION_ADDR;
    command = (RECT_CODE << 21) | ((color & 3) << 19) | ((x & 0x3FF) << 9) | (y & 0x1FF);
    *memSet = command;

    memSet = (int *)DRAW_CONTROL_ADDR;
    command = (1 << 31) | ((width & 0x3FF) << 9) | (height & 0x1FF);
    *memSet = command;
}

void drawCircle(int x, int y, int radius, color_t color)
{
    int *memSet;
    int command;

    memSet = (int *)DRAW_LOCATION_ADDR;
    command = (CIRCLE_CODE << 21) | ((color & 3) << 19) | ((x & 0x3FF) << 9) | (y & 0x1FF);
    *memSet = command;

    memSet = (int *)DRAW_CONTROL_ADDR;
    command = (1 << 31) | (radius & 0x7FFFF);
    *memSet = command;
}

void drawSprite(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;
    int command;

    memSet = (int *)DRAW_LOCATION_ADDR;
    command = (SPRITE_CODE << 21) | ((color & 3) << 19) | ((x & 0x3FF) << 9) | (y & 0x1FF);
    *memSet = command;

    memSet = (int *)SPRITE_ADDR;
    command = addr;
    *memSet = command;

    // memSet = (int *)DRAW_CONTROL_ADDR;
    // command = (1 << 31) | (scale & 0x7FFFF);
    // *memSet = command;
}


void drawScore(int startX, int y, int score, color_t color) {
    drawRect(startX, y, 160, 32, 0);

    if (score > 0xFFF) {
        score = 0xFFF;
    }

    int hundreds = (score >> 8) & 0xF;
    int tens = (score >> 4) & 0xF;
    int ones = score & 0xF;

    int xC = startX + 16;
    int xO = startX + 32;
    int xR = startX + 48;
    int xE = startX + 64;
    int xColon = startX + 80;
    int xHundred = startX + 112;
    int xTen = startX + 128;
    int xOne = startX + 144;
    char hundred;
    char ten;
    char one;

    if (hundreds > 9) {
        hundred = 'a' + (hundreds - 10);
    } else {
        hundred = '0' + hundreds;
    }

    if (tens > 9) {
        ten = 'a' + (tens - 10);
    } else {
        ten = '0' + tens;
    }

    if (ones > 9) {
        one = 'a' + (ones - 10);
    } else {
        one = '0' + ones;
    }

    drawChar(startX, y, 's', color);
    drawChar(xC, y, 'c', color);
    drawChar(xO, y, 'o', color);
    drawChar(xR, y, 'r', color);
    drawChar(xE, y, 'e', color);
    drawChar(xColon, y, ':', color);
    drawChar(xHundred, y, hundred, color);
    drawChar(xTen, y, ten, color);
    drawChar(xOne, y, one, color);
}

void drawChar(int x, int y, char c, color_t color) {
    if (c == '!') {
        drawLetter(x, y, 1, EXCLAMATION, color);
    } else if (c == '?') {
        drawLetter(x, y, 1, QUESTION, color);
    } else if (c == ':') {
        drawLetter(x, y, 1, COLON, color);
    } else if (c == '-') {
        drawLetter(x, y, 1, HYPHEN, color);
    } else if (c >= '0' && c <= ':') { // Digits
        int addr = LETTER_BASE + LETTER_OFFSET * (26 + (c - '0'));
        drawLetter(x, y, 1, addr, color);
    } else { // Letters
        int addr = LETTER_BASE + LETTER_OFFSET * (c - 'a');
        drawLetter(x, y, 1, addr, color);
    }
}

void drawLetter(int x, int y, int scale, int addr, color_t color)
{
    int *memSet;
    int command;

    memSet = (int *)DRAW_LOCATION_ADDR;
    command = (LETTER_CODE << 21) | ((color & 3) << 19) | ((x & 0x3FF) << 9) | (y & 0x1FF);
    *memSet = command;

    memSet = (int *)SPRITE_ADDR;
    command = addr;
    *memSet = command;

    // memSet = (int *)DRAW_CONTROL_ADDR;
    // command = (1 << 31) | (scale & 0x7FFFF);
    // *memSet = command;
}

void setLED(bool value, int led, int *ledState)
{
    int *memSet;
    int command;
    bool val = value & 1;

    memSet = (int *)LED_ADDR;

    if (val)
    {
        command = (*ledState) | (1 << led);
    }
    else
    {
        command = (*ledState) & (~(1 << led));
    }

    *memSet = command;
    *ledState = command;
}

uint getTimerValue()
{
    uint *memSet;

    memSet = (uint *)TIMER_ADDR;
    return *memSet;
}

bool checkLocationForColor(int x, int y, int radius)
{
    int *memSet;
    int command;

    memSet = (int *)DETECT_LOCATION_ADDR;
    command = ((x & 0x3FF) << 19) | ((y & 0x1FF) << 10) | (radius & 0x3FF);
    *memSet = command;

    memSet = (int *)COLOR_LOCATED_ADDR;
    return (*memSet) & 1;
}

int getCursorLocation()
{
    int *memSet;
    memSet = (int *)DETECT_LOCATION_ADDR;

    return *memSet;
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
    int command;

    memSet = (int *)SPART_WRITE_ADDR;
    command = (value & 0xFF);
    *memSet = command;
}

void getIO(int *timer, char *SPART, int *x, int *y, bool *present, bool *valid)
{
    *timer = getTimerValue();
    *SPART = getSPART();
}

int abs(int a)
{
    if (a < 0)
    {
        return 0 - a;
    }
    return a;
}

int sign(int a)
{
    if (a < 0)
    {
        return -1;
    }
    return 1;
}

int multiply(int a, int b)
{
    int abs_a = abs(a);
    int abs_b = abs(b);

    int result = 0;
    int i;

    if (!a || !b)
    {
        return 0;
    }

    if (abs_a <= abs_b)
    {
        if (a < 0)
        {
            a = 0 - a;
            b = 0 - b;
        }

        for (i = 0; i < a; i++)
        {
            result += b;
        }

        return result;
    }
    else
    {
        if (b < 0)
        {
            a = 0 - a;
            b = 0 - b;
        }

        for (i = 0; i < b; i++)
        {
            result += a;
        }
    }
}

int divide(int a, int b)
{
    if (!a || !b)
    {
        return 0;
    }

    int sign_a = sign(a);
    int sign_b = sign(b);
    int abs_a = abs(a);
    int abs_b = abs(b);

    int result = 0;
    if (abs_a >= abs_b)
    {
        while (abs_a >= abs_b)
        {
            abs_a -= abs_b;
            result++;
        }
    }
    else
    {
        return 0;
    }

    if (sign_a != sign_b)
    {
        result = 0 - result;
    }

    return result;
}

int remainder(int a, int b)
{
    if (!a || !b)
    {
        return 0;
    }

    int sign_a = sign(a);
    int sign_b = sign(b);
    int abs_a = abs(a);
    int abs_b = abs(b);

    if (abs_a >= abs_b)
    {
        while (abs_a >= abs_b)
        {
            abs_a -= abs_b;
        }
    }

    if (sign_a != sign_b)
    {
        abs_a = 0 - abs_a;
    }

    return abs_a;
}