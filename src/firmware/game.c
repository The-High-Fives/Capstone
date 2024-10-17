#include "defs.h"
#include "levels.h"

void setupGame(Game *game)
{
    game->score = 0;
    game->time = 0;
    game->activeLevel = -1;
    game->onStartScreen = true;
    game->isGameOver = false;
    game->quitGame = false;

    game->numLevels = LEVEL_COUNT;
    game->levels = createAllLevels();
}

void resetGame(Game *game)
{
    game->score = 0;
    game->time = 0;
    game->activeLevel = 0;
    game->onStartScreen = false;
    game->isGameOver = false;

    game->numLeftActiveDots = 0;
    game->numRightActiveDots = 0;

    for (int i = 0; i < game->numLevels; i++)
    {
        Level *level = &game->levels[i];

        for (int j = 0; j < level->numLeftDots; j++)
        {
            Dot *dot = level->leftDots[j];
            dot->isHit = false;
        }

        for (int j = 0; j < level->numRightDots; j++)
        {
            Dot *dot = level->rightDots[j];
            dot->isHit = false;
        }
    }
}

void startLevel(Game *game, int level)
{
    if (level < 0 || level >= game->numLevels)
    {
        return;
    }

    game->activeLevel = level;

    Level *activeLevel = game->levels[game->activeLevel];
    game->time = 0;
    game->score = 0;
    game->numLeftActiveDots = 0;
    game->numRightActiveDots = 0;
    game->leftActiveDots = malloc(sizeof(Dot *) * activeLevel->numLeftDots);
    game->rightActiveDots = malloc(sizeof(Dot *) * activeLevel->numRightDots);
}

void finishLevel(Game *game)
{
    game->activeLevel = -1;
    game->time = 0;
    game->score = 0;
    game->numLeftActiveDots = 0;
    game->numRightActiveDots = 0;

    free(game->leftActiveDots);
    game->leftActiveDots = NULL;
    free(game->rightActiveDots);
    game->rightActiveDots = NULL;
}

int calculateScore(int hitTime, int time)
{
    int calcScore = 2 / (hitTime - time);

    if (calcScore < 1)
    {
        return 1;
    }

    if (calcScore > 10)
    {
        return 10;
    }

    return calcScore;
}

bool hitLeft(Game *game, int x, int y)
{
    Dot *dot = hitDot(game->leftActiveDots, game->numLeftActiveDots, x, y);

    if (dot != NULL)
    {
        game->score += calculateScore(dot->hitTime, game->time);
        return true;
    }

    return false;
}

bool hitRight(Game *game, int x, int y)
{
    Dot *dot = hitDot(game->rightActiveDots, game->numRightActiveDots, x, y);

    if (dot != NULL)
    {
        game->score += calculateScore(dot->hitTime, game->time);
        return true;
    }

    return false;
}

Dot *hitDot(Dot **dots, int numDots, int x, int y)
{
    Dot **sortedDots = sortDotsByTime(dots, numDots);

    Dot *hit_dot = NULL;

    for (int i = 0; i < numDots; i++)
    {
        Dot *dot = sortedDots[i];

        if (dot->isHit)
        {
            continue;
        }

        int dx = x - dot->x;
        int dy = y - dot->y;

        if (dx * dx + dy * dy <= DOT_RADIUS * DOT_RADIUS)
        {
            dot->isHit = true;
            hit_dot = dot;
            break;
        }
    }
}

void step(Game *game, int dt)
{
    if (game->activeLevel >= game->numLevels || game->activeLevel < 0)
    {
        return;
    }

    game->time += dt;

    Level *level = &game->levels[game->activeLevel];

    for (int i = 0; i < level->numLeftDots; i++)
    {
        Dot *dot = level->leftDots[i];

        bool isDotActive = false;

        for (int j = 0; j < game->numLeftActiveDots; j++)
        {
            if (game->leftActiveDots[j] == dot)
            {
                isDotActive = true;
                break;
            }
        }

        if (dot->appearTime <= game->time && dot->hitTime > game->time && !dot->isHit && !isDotActive)
        {
            game->leftActiveDots[game->numLeftActiveDots] = dot;
            game->numLeftActiveDots++;
        }
        else if ((dot->hitTime <= game->time || dot->isHit) && isDotActive)
        {
            for (int j = i; j < game->numLeftActiveDots - 1; j++)
            {
                game->leftActiveDots[j] = game->leftActiveDots[j + 1];
            }
            game->numLeftActiveDots--;
        }
    }

    for (int i = 0; i < level->numRightDots; i++)
    {
        Dot *dot = level->rightDots[i];

        bool isDotActive = false;

        for (int j = 0; j < game->numRightActiveDots; j++)
        {
            if (game->rightActiveDots[j] == dot)
            {
                isDotActive = true;
                break;
            }
        }

        if (dot->appearTime <= game->time && dot->hitTime > game->time && !dot->isHit)
        {
            game->rightActiveDots[game->numRightActiveDots] = dot;
            game->numRightActiveDots++;
        }
        else if ((dot->hitTime <= game->time || dot->isHit) && isDotActive)
        {
            for (int j = i; j < game->numRightActiveDots - 1; j++)
            {
                game->rightActiveDots[j] = game->rightActiveDots[j + 1];
            }
            game->numRightActiveDots--;
        }
    }

    if (game->time > level->leftDots[level->numLeftDots - 1]->hitTime && game->time > level->rightDots[level->numRightDots - 1]->hitTime)
    {
        game->isGameOver = true;
    }
}

Dot **sortDotsByTime(Dot **dots, int numDots)
{
    if (numDots <= 1)
    {
        return dots;
    }

    Dot **leftSortedDots = sortDotsByTime(dots, numDots / 2);
    Dot **rightSortedDots = sortDotsByTime(dots + numDots / 2, numDots - numDots / 2);

    Dot **sortedDots = malloc(sizeof(Dot *) * numDots);
    if (sortedDots == NULL)
    {
        return dots;
    }

    int leftIndex = 0;
    int rightIndex = 0;
    int sortedIndex = 0;
    int leftSize = numDots / 2;
    int rightSize = numDots - leftSize;

    while (leftIndex < leftSize && rightIndex < rightSize)
    {
        if (leftSortedDots[leftIndex]->hitTime < rightSortedDots[rightIndex]->hitTime)
        {
            sortedDots[sortedIndex++] = leftSortedDots[leftIndex++];
        }
        else
        {
            sortedDots[sortedIndex++] = rightSortedDots[rightIndex++];
        }
    }

    while (leftIndex < leftSize)
    {
        sortedDots[sortedIndex++] = leftSortedDots[leftIndex++];
    }

    while (rightIndex < rightSize)
    {
        sortedDots[sortedIndex++] = rightSortedDots[rightIndex++];
    }

    for (int i = 0; i < numDots; i++)
    {
        dots[i] = sortedDots[i];
    }

    free(sortedDots);

    return dots;
}
