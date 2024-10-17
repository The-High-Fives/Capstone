#include "defs.h"
#include "levels.h"

Level **createAllLevels()
{
    Level **levels = malloc(sizeof(Level *) * LEVEL_COUNT);

    if (levels == NULL)
    {
        return NULL;
    }

    levels[0] = createLevel1();
    levels[1] = createLevel2();
    levels[2] = createLevel3();

    return levels;
}

Level *createLevel1()
{
    Level *level = malloc(sizeof(Level));

    if (level == NULL)
    {
        return NULL;
    }

    level->levelNumber = 1;
    level->songId = 1;

    return level;
}

Level *createLevel2()
{
    Level *level = malloc(sizeof(Level));

    if (level == NULL)
    {
        return NULL;
    }

    level->levelNumber = 1;
    level->songId = 1;

    return level;
}

Level *createLevel3()
{
    Level *level = malloc(sizeof(Level));

    if (level == NULL)
    {
        return NULL;
    }

    level->levelNumber = 1;
    level->songId = 1;

    return level;
}