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
    bool *present;
    bool *valid;

    int *dt;
    char *SPART;

    while (!game->quitGame)
    {
        getIO(dt, SPART, handX, handY, present, valid);

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
            step(game, *dt, *handX, *handY);
            drawGameScreen(game);
        }
    }

    drawGameCompleteScreen(game);

    game = NULL;

end:
    goto end;

    return 0;
}