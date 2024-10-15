#pragma once

#define NULL (void *)0
#define true 1
#define false 0

#define uint8_t unsigned char

const int DOT_RADIUS = 20;

typedef struct
{
    uint8_t r;
    uint8_t g;
    uint8_t b;
} Color;

typedef struct
{
    int x;
    int y;
    Color color;
    int hitTime;
    int holdTime;
    int appearTime;
    bool isHit;
} Dot;

typedef struct
{
    Dot **leftDots;
    int numLeftDots;

    Dot **rightDots;
    int numRightDots;

    int levelNumber;
} Level;

typedef struct
{
    int score;
    int time;
    int activeLevel;

    Level **levels;
    int numLevels;

    Dot **leftActiveDots;
    int numLeftActiveDots;

    Dot **rightActiveDots;
    int numRightActiveDots;
} Game;

int calculateScore(int hitTime, int time);
Dot **sortDotsByTime(Dot **dots, int numDots);
void step(Game *game, int dt);