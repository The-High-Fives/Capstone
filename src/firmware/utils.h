#pragma once

#include "defs.h"

#define COLOR_ADDR 0x4000
#define DRAW_LOCATION_ADDR 0x4100
#define DRAW_CONTROL_ADDR 0x4104
#define SPRITE_ADDR 0x4108
#define TIMER_ADDR 0x4200
#define HAND_LOCATION_ADDR 0x4204
#define SPART_ADDR 0x4208

void drawCircle(int x, int y, int radius, color_t color);
void drawRect(int x, int y, int width, int height, color_t color);
void drawSprite(int x, int y, int memoryLocation, int wordCount, color_t color);
void setColor(color_t addr, Color color);

int getTimerValue();
int getHandLocation();
int getSPART();
void getIO(int *timer, int *handLocation, int *SPART);