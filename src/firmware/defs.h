#pragma once

#define NULL (void *)0
#define true 1
#define false 0
#define bool char

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
    int songId;
} Level;

typedef struct
{
    int score;
    int time;
    int activeLevel;
    bool onStartScreen;
    bool isGameOver;
    bool quitGame;

    Level **levels;
    int numLevels;

    Dot **leftActiveDots;
    int numLeftActiveDots;

    Dot **rightActiveDots;
    int numRightActiveDots;
} Game;

void setupGame(Game *game);
void resetGame(Game *game);
int calculateScore(int hitTime, int time);
bool hitLeft(Game *game, int x, int y);
bool hitRight(Game *game, int x, int y);
Dot *hitDot(Game *game, int x, int y);
void step(Game *game, int dt);
Dot **sortDotsByTime(Dot **dots, int numDots);