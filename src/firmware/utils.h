#ifndef UTILS_H
#define UTILS_H

// Peripheral Addresses
#define LED_ADDR 0x40000000
#define TIMER_ADDR 0x40000004
#define SPART_READ_ADDR 0x4000001D
#define SPART_WRITE_ADDR 0x4000001C

// PRU Addresses
#define DRAW_LOCATION_ADDR 0x40000100
#define DRAW_CONTROL_ADDR 0x40000104
#define SPRITE_ADDR 0x40000108
#define COLOR_ADDR 0x4000010C

// IPU Addresses
#define DETECT_LOCATION_ADDR 0x40000200
#define COLOR_LOCATED_ADDR 0x40000204

#define RECT_CODE 0b00
#define CIRCLE_CODE 0b01
#define SPRITE_CODE 0b10
#define LETTER_CODE 0b11

#define LETTER_BASE 0
#define LETTER_OFFSET 512

#define EXCLAMATION 18432
#define QUESTION 18944
#define COLON 19456
#define HYPHEN 19968

#define color_t unsigned char
#define bool unsigned char
#define uint unsigned int

#define NULL (void *)0
#define true 1
#define false 0

typedef struct
{
    int r;
    int g;
    int b;
} Color;

void drawCircle(int x, int y, int radius, color_t color);
void drawRect(int x, int y, int width, int height, color_t color);
void drawSprite(int x, int y, int scale, int addr, color_t color);
void drawChar(int x, int y, char c, color_t color);
void drawScore(int startX, int y, int score, color_t color);
void drawLetter(int x, int y, int scale, int addr, color_t color);
void setColor(color_t addr, Color color);
void setLED(bool value, int led, int *ledState);

uint getTimerValue();
bool checkLocationForColor(int x, int y, int radius);
int getCursorLocation();
char getSPART();
void setSPART(char value);
void getIO(int *timer, char *SPART, int *x, int *y, bool *present, bool *valid);

int abs(int a);
int sign(int a);
int multiply(int a, int b);
int divide(int a, int b);
int remainder(int a, int b);

#endif