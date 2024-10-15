#include "defs.h"

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
