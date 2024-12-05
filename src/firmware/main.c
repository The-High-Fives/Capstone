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

    int *handX;
    int *handY;

    while (!game->quitGame)
    {
        int *dt;
        char *SPART;
        getIO(dt, SPART, handX, handY);

        if (game->onStartScreen)
        {
            drawStartScreen(game);

            if (*SPART == END_SIGNAL)
            {
                break;
            }

            if (*SPART == START_SIGNAL)
            {
                startLevel(game, 0);
            }
        }
        else if (game->isGameOver)
        {
            finishLevel(game);

            if (*SPART == END_SIGNAL)
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

    drawGameCompleteScreen(game);

    game = NULL;

end:
    goto end;

    return 0;
}