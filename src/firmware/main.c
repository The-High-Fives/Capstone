#include "defs.h"

int main()
{
    Game *game = malloc(sizeof(Game));

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

    free(game);
    game = NULL;

    return 0;
}