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

// ================================================================================================
#define CURSOR_RADIUS 5
#define CIRCLE_RADIUS 20
int main()
{
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
    
    // Color c2 = {0xF0F, 0xFFF, 0x0F0};
    // setColor(2, c2);
     drawRect(0, 0, 640, 480, 0);
    // drawScore(50, 300, 5, 2);
    // //drawScore(10, 200, 7, 2);
        // if (x > 100 && x < 140 && y > 100 && y < 140)
        // {
        //         Color c2 = {0xF0F, 0xFFF, 0x0F0};
        //         setColor(3, c2);
        //     // drawCircle(120, 120, 20, 0);
        //     // //hit = hit + 1;
        //     // drawCircle(200, 200, 10, 2);
        // }
        // else
        // {
        //         Color c3 = {0x00F, 0x00F, 0x0FF};
        //         setColor(3, c3);
        //     // drawCircle(120, 120, 20, 1);
        //     // //hit = hit + 1;
        //     // drawCircle(200, 200, 10, 0);
        // }
    while (1)
    {
        loc = getCursorLocation();
        sh1 = loc >> 1;
        sh2 = loc >> 2;
        sh3 = loc >> 12;
        present = sh1 & 1;
        valid = loc & 1;
        rect_x = prev_x - 24;
        rect_y = prev_y - 24;
        rev_x = sh2 & 0x3FF;
        x = 640 - rev_x;
        y = sh3 & 0x1FF;

        // game_x_lower = 40 + hit << 5;
        // game_y_lower = 40 + hit << 3;
        // game_x_upper = 70 + hit << 5;
        // game_y_upper = 70 + hit << 3;
        // game_x_loc = 60 + hit << 5;
        // game_y_loc = 60 + hit << 3;


        if (present && valid)
        {
        //  if (x > 100 && x < 140 && y > 100 && y < 140)
        // {
        //         Color c2 = {0xF0F, 0xFFF, 0x0F0};
        //         setColor(3, c2);
        //     // drawCircle(120, 120, 20, 0);
        //     // //hit = hit + 1;
        //     // drawCircle(200, 200, 10, 2);
        // }
        // else
        // {
        //         Color c3 = {0x00F, 0x00F, 0x0FF};
        //         setColor(3, c3);
        //     // drawCircle(120, 120, 20, 1);
        //     // //hit = hit + 1;
        //     // drawCircle(200, 200, 10, 0);
        // }

        game_x_lower = 60 + (hit);
        game_y_lower = 60 + (hit);
        game_x_upper = 140 + (hit);
        game_y_upper = 140 + (hit);
        game_x_loc = 90 + (hit);
        game_y_loc = 90 + (hit);
        // if (!(hit ^ 4))
        // {
        //     hit = 0;
        // }
        if (x > game_x_lower && x < game_x_upper && y > game_y_lower && y < game_y_upper)
        {
                Color c2 = {0xF0F, 0xFFF, hit};
                setColor(3, c2);
             drawCircle(game_x_loc, game_y_loc, 20, 0);
             hit = hit + 30;
             //drawScore(50, 300, hit, 2);
            //drawCircle(200, 200, 10, 2);
        }
        else
        {
                Color c3 = {0x000FF0FF, 0x00F, 0x000};
                setColor(3, c3);
            //drawCircle(200, 200, 10, 0);
             drawCircle(game_x_loc, game_y_loc, 20, 1);
        }
            prev_x = x;
            prev_y = y;
            drawScore(5, 30, hit, 2);
            drawRect(rect_x, rect_y, 48, 48, 0);
            drawCircle(x, y, 20, 3);
        }
    }
end:
    goto end;
    return 0;
}

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

void drawScore(int startX, int y, int score, color_t color)
{
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
    drawRect(startX, y, xOne, 40, 0);
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

// char getSPART()
// {
//     char *memSet;

//     memSet = (char *)SPART_READ_ADDR;
//     return *memSet;
// }

// void setSPART(char value)
// {
//     int *memSet;
//     int command;

//     memSet = (int *)SPART_WRITE_ADDR;
//     command = (value & 0xFF);
//     *memSet = command;
// }

// void getIO(int *timer, char *SPART, int *x, int *y, bool *present, bool *valid)
// {
//     *timer = getTimerValue();
//     *SPART = getSPART();
// }
