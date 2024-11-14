#include "defs.h"
#include "levels.h"

void createAllLevels(Game *game)
{
    game->numLevels = LEVEL_COUNT;
    createLevel1(&game->levels[0]);
    createLevel2(&game->levels[1]);
    createLevel3(&game->levels[2]);
}

void createLevel1(Level *level)
{
    level->levelNumber = 1;
    level->songId = 1;
}

void createLevel2(Level *level)
{
    level->levelNumber = 2;
    level->songId = 2;
}

void createLevel3(Level *level)
{
    level->levelNumber = 3;
    level->songId = 3;
}