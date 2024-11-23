#ifndef UTILS_H
#define UTILS_H

// Peripheral Addresses
#define LED_ADDR 0x4000
#define TIMER_ADDR 0x4004
#define SPART_READ_ADDR 0x4008
#define SPART_WRITE_ADDR 0x4009

// PRU Addresses
#define DRAW_LOCATION_ADDR 0x4100
#define DRAW_CONTROL_ADDR 0x4104
#define SPRITE_ADDR 0x4108
#define COLOR_ADDR 0x410C

// IPU Addresses
#define DETECT_LOCATION_ADDR 0x4200
#define COLOR_LOCATED_ADDR 0x4204

#define RECT_CODE 0b00
#define CIRCLE_CODE 0b01
#define SPRITE_CODE 0b10
#define LETTER_CODE 0b11

#define uint8_t unsigned char
#define color_t unsigned char
#define bool unsigned char

#define NULL (void *)0
#define true 1
#define false 0

typedef struct
{
    uint8_t r;
    uint8_t g;
    uint8_t b;
} Color;

void drawCircle(int x, int y, int radius, color_t color);
void drawRect(int x, int y, int width, int height, color_t color);
void drawSprite(int x, int y, int scale, int addr, color_t color);
void drawLetter(int x, int y, int scale, int addr, color_t color);
void setColor(color_t addr, Color color);
void setLED(bool value, int led);

int getTimerValue();
bool checkLocationForColor(int x, int y, int radius);
char getSPART();
void setSPART(char value);
void getIO(int *timer, char *SPART);

#endif