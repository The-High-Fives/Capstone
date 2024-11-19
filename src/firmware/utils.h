#pragma once

#include "defs.h"

void drawCircle(int x, int y, int radius, color_t color);
void drawRect(int x, int y, int width, int height, color_t color);
void drawSprite(int x, int y, int memoryLocation, int wordCount, color_t color);
void setColor(color_t addr, Color color);