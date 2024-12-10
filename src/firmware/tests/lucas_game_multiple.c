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
void drawGameCircle(int x, int y, int o_radius, int i_radius, color_t color);
void drawRect(int x, int y, int width, int height, color_t color);
void drawSprite(int x, int y, int scale, int addr, color_t color);
void drawChar(int x, int y, char c, color_t color);
void drawScore(int startX, int y, int score, color_t color);
void drawNumber(int x, int y, int number, color_t color);
void drawLetter(int x, int y, int scale, int addr, color_t color);
void setColor(color_t addr, Color color);
void setLED(bool value, int led, int *ledState);

uint getTimerValue();
bool checkLocationForColor(int x, int y, int radius);
int getCursorLocation();
char getSPART();
void setSPART(char value);
void getIO(int *timer, char *SPART, int *x, int *y, bool *present, bool *valid);

int absolute(int a);
int sign(int a);
int multiply(int a, int b);
int divide(int a, int b);
int modulo(int a, int b);

uint rand(uint lfsr);

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

typedef struct
{
    int x;
    int y;
    int noHit;
} Dot;

// ================================================================================================

#define CURSOR_RADIUS 10
#define CIRCLE_RADIUS 20
#define CIRCLE_RADIUS_SQ 400

int main()
{
    drawRect(0, 0, 640, 480, 0);

    int loc;
    int sh1;
    int sh2;
    int sh3;
    int prev_x = 0;
    int prev_y = 0;
    int x = 0;
    int rev_x;
    int y = 0;
    int rect_x;
    int score = 0;
    int rect_y;
    bool present;
    bool valid;
    int hit = 0;
    int game_x_lower;
    int game_y_lower;
    int game_x_loc;
    int game_y_loc;
    int game_x_upper;
    int game_y_upper;
    uint panic = 0;
    int no_hit = 40;

    int i = 0;
    int c_x = 0;
    int c_y = 0;
    int x_diff = 0;
    int y_diff = 0;
    int x_diff_sq = 0;
    int y_diff_sq = 0;
    int circle_diff = 0;
    uint lfsr = 0xACE1u;

    int dotsX[3];
    int dotsY[3];
    int dotsNoHit[3];

    lfsr = rand(lfsr);
    dotsX[0] = modulo(lfsr, SCREEN_WIDTH + 1);

    lfsr = rand(lfsr);
    dotsY[0] = modulo(lfsr, SCREEN_HEIGHT + 1);
    dotsNoHit[0] = 40;

    lfsr = rand(lfsr);
    dotsX[1] = modulo(lfsr, SCREEN_WIDTH + 1);

    lfsr = rand(lfsr);
    dotsY[1] = modulo(lfsr, SCREEN_HEIGHT + 1);
    dotsNoHit[1] = 40;

    lfsr = rand(lfsr);
    dotsX[2] = modulo(lfsr, SCREEN_WIDTH + 1);

    lfsr = rand(lfsr);
    dotsY[2] = modulo(lfsr, SCREEN_HEIGHT + 1);
    dotsNoHit[2] = 40;

    do
    {
        loc = getCursorLocation();
        sh1 = loc >> 1;
        sh2 = loc >> 2;
        sh3 = loc >> 12;
        present = sh1 & 1;
        valid = loc & 1;
        rect_x = prev_x - 12;
        rect_y = prev_y - 12;
        rev_x = sh2 & 0x3FF;
        x = 640 - rev_x;
        y = sh3 & 0x1FF;

        if (present && valid)
        {
            drawRect(rect_x, rect_y, 24, 24, 0);
            drawScore(1, 1, score, 2);

            for (i = 0; i < 3; i++)
            {
                c_x = dotsX[i];
                c_y = dotsY[i];
                no_hit = dotsNoHit[i];
                drawNumber(500, 0, i, 2);
                drawNumber(500, 36, c_x, 2);
                drawNumber(500, 72, c_y, 2);
                drawNumber(500, 108, no_hit, 2);

                x_diff = c_x - x;
                y_diff = c_y - y;

                x_diff_sq = multiply(x_diff, x_diff);
                y_diff_sq = multiply(y_diff, y_diff);

                circle_diff = x_diff_sq + y_diff_sq;

                if (circle_diff < CIRCLE_RADIUS_SQ)
                {
                    Color c2 = {0xF0F, 0xFFF, hit};
                    setColor(3, c2);
                    drawGameCircle(c_x, c_y, no_hit, CIRCLE_RADIUS, 0);
                    score = score + 4;
                    no_hit = 40;

                    lfsr = rand(lfsr);
                    c_x = modulo(lfsr, SCREEN_WIDTH + 1);

                    lfsr = rand(lfsr);
                    c_y = modulo(lfsr, SCREEN_HEIGHT + 1);
                }
                else
                {
                    no_hit = no_hit - 1;
                    if (no_hit == 20)
                    {
                        no_hit = 40;
                        if (score != 0)
                        {
                            score = score - 4;
                        }
                    }
                    Color game_circle = {no_hit, no_hit << 5, 0xFF0};
                    setColor(1, game_circle);
                    drawGameCircle(c_x, c_y, no_hit, CIRCLE_RADIUS, 1);
                }

                dotsX[i] = c_x;
                dotsY[i] = c_y;
                dotsNoHit[i] = no_hit;
            }

            prev_x = x;
            prev_y = y;
            drawCircle(x, y, CURSOR_RADIUS, 3);
        }
    } while (1);

end:
    goto end;
    return 0;
}

// ================================================================================================

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

void drawGameCircle(int x, int y, int o_radius, int i_radius, color_t color)
{
    drawCircle(x, y, (o_radius + 4), 0);
    drawCircle(x, y, (o_radius + 2), color);
    drawCircle(x, y, (o_radius), 0);
    drawCircle(x, y, i_radius, color);
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

void drawScore(int startX, int y, int score, color_t color)
{
    drawRect(startX, y, 160, 32, 0);

    if (score > 0xFFF)
    {
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

    if (hundreds > 9)
    {
        hundred = 'a' + (hundreds - 10);
    }
    else
    {
        hundred = '0' + hundreds;
    }

    if (tens > 9)
    {
        ten = 'a' + (tens - 10);
    }
    else
    {
        ten = '0' + tens;
    }

    if (ones > 9)
    {
        one = 'a' + (ones - 10);
    }
    else
    {
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

void drawNumber(int x, int y, int number, color_t color)
{
    drawRect(x, y, 48, 32, 0);

    int hundreds = (number >> 8) & 0xF;
    int tens = (number >> 4) & 0xF;
    int ones = number & 0xF;

    int xHundred = x;
    int xTen = x + 16;
    int xOne = x + 32;

    char hundred;
    char ten;
    char one;

    if (hundreds > 9)
    {
        hundred = 'a' + (hundreds - 10);
    }
    else
    {
        hundred = '0' + hundreds;
    }

    if (tens > 9)
    {
        ten = 'a' + (tens - 10);
    }
    else
    {
        ten = '0' + tens;
    }

    if (ones > 9)
    {
        one = 'a' + (ones - 10);
    }
    else
    {
        one = '0' + ones;
    }

    drawChar(xHundred, y, hundred, color);
    drawChar(xTen, y, ten, color);
    drawChar(xOne, y, one, color);
}

void drawChar(int x, int y, char c, color_t color)
{
    if (c == '!')
    {
        drawLetter(x, y, 1, EXCLAMATION, color);
    }
    else if (c == '?')
    {
        drawLetter(x, y, 1, QUESTION, color);
    }
    else if (c == ':')
    {
        drawLetter(x, y, 1, COLON, color);
    }
    else if (c == '-')
    {
        drawLetter(x, y, 1, HYPHEN, color);
    }
    else if (c >= '0' && c <= ':')
    { // Digits
        int addr = LETTER_BASE + LETTER_OFFSET * (26 + (c - '0'));
        drawLetter(x, y, 1, addr, color);
    }
    else
    { // Letters
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

int absolute(int a)
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
    int abs_a = absolute(a);
    int abs_b = absolute(b);

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
    int abs_a = absolute(a);
    int abs_b = absolute(b);

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

int modulo(int a, int b)
{
    if (!a || !b)
    {
        return 0;
    }

    int sign_a = sign(a);
    int sign_b = sign(b);
    int abs_a = absolute(a);
    int abs_b = absolute(b);

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

uint rand(uint lfsr)
{
    uint bit;
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
    lfsr = (lfsr >> 1) | (bit << 15);
    return lfsr;
}