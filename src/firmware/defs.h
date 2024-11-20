#pragma once

#define NULL (void *)0
#define true 1
#define false 0
#define bool char
#define color_t unsigned char

#define uint8_t unsigned char

#define START_SIGNAL 97

#define MAX_DOTS 50
#define MAX_LEFT_DOTS 50
#define MAX_RIGHT_DOTS 50
#define MAX_LEVELS 3

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

#define DOT_RADIUS 20

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
    color_t color;
    int hitTime;
    int holdTime;
    int appearTime;
    bool isHit;
} Dot;

typedef struct
{
    Dot leftDots[MAX_LEFT_DOTS];
    int numLeftDots;

    Dot rightDots[MAX_RIGHT_DOTS];
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

    Level levels[MAX_LEVELS];
    int numLevels;

    Dot leftActiveDots[MAX_LEFT_DOTS];
    int numLeftActiveDots;

    Dot rightActiveDots[MAX_RIGHT_DOTS];
    int numRightActiveDots;
} Game;

void setupGame(Game *game);
void resetGame(Game *game);
int calculateScore(int hitTime, int time);
bool hitLeft(Game *game, int x, int y);
bool hitRight(Game *game, int x, int y);
Dot *hitDot(Dot *dots, int numDots, int x, int y);
void step(Game *game, int dt);
void sortDotsByTime(Dot *dots, int numDots);
void finishLevel(Game *game);
void startLevel(Game *game, int level);
void drawStartScreen(Game *game);
void drawGameOverScreen(Game *game);
void drawGameScreen(Game *game);