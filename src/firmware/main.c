#include "defs.h"

int main()
{
    Game g;
    Game *game = &g;
    Dot leftDots[MAX_LEFT_DOTS];
    Dot rightDots[MAX_RIGHT_DOTS];

    if (game == NULL)
    {
        return 1;
    }

    setupGame(game);

    while (!game->quitGame)
    {
        int *dt;
        int *handLocation;
        int *SPART;
        getIO(dt, handLocation, SPART);

        if (game->onStartScreen)
        {
            drawStartScreen(game);

            if (game->quitGame)
            {
                break;
            }

            if (SPART == START_SIGNAL)
            {
                startLevel(game, 0);
            }
        }
        else if (game->isGameOver)
        {
            finishLevel(game);

            if (game->quitGame)
            {
                break;
            }

            drawGameOverScreen(game);
        }
        else
        {
            step(game, *dt);
            drawGameScreen(game);
        }
    }

    game = NULL;

    return 0;
}