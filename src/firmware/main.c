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
        if (game->onStartScreen)
        {
            // getIO();
            // drawStartScreen(game);

            /*
            if (game->quitGame)
            {
                break;
            }

            if (levelSelected)
            {
                startLevel(game, selectedLevel);
            }
            */
        }
        else if (game->isGameOver)
        {
            finishLevel(game);
            // getIO();
            /*
            if (game->quitGame)
            {
                break;
            }
            */
            //  drawGameOverScreen(game);
        }
        else
        {
            int dt = 0;
            // getIO();
            step(game, dt);
            // drawGameScreen(game);
        }
    }

    game = NULL;

    return 0;
}