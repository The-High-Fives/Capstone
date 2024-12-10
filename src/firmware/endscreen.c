#define es_STARTX 224
#define es_Y 150
#define es_Y_S 200
#define es_Y_T 250
#define es_SECOND_X 200
#define es_THIRD_X 200
#define es_COLOR  3
#define es_COLOR_S  1
#define es_COLOR_T  2

void endScreen(int score)
{

    drawChar(es_STARTX, es_Y, 'g', es_COLOR);
    drawChar(es_STARTX + 16, es_Y, 'a', es_COLOR);
    drawChar(es_STARTX + 32, es_Y, 'm', es_COLOR);
    drawChar(es_STARTX + 48, es_Y, 'e', es_COLOR);
    drawChar(es_STARTX + 80, es_Y, 'o', es_COLOR);
    drawChar(es_STARTX + 96, es_Y, 'v', es_COLOR);
    drawChar(es_STARTX + 112, es_Y, 'e', es_COLOR);
    drawChar(es_STARTX + 128, es_Y, 'r', es_COLOR);
    drawChar(es_STARTX + 144, es_Y, '!', es_COLOR);

    drawChar(es_SECOND_X + 16, es_Y_S, 'p', es_COLOR_S);
    drawChar(es_SECOND_X + 32, es_Y_S, 'l', es_COLOR_S);
    drawChar(es_SECOND_X + 48, es_Y_S, 'a', es_COLOR_S);
    drawChar(es_SECOND_X + 64, es_Y_S, 'y', es_COLOR_S);
    drawChar(es_SECOND_X + 96, es_Y_S, 'a', es_COLOR_S);
    drawChar(es_SECOND_X + 112, es_Y_S, 'g', es_COLOR_S);
    drawChar(es_SECOND_X + 128, es_Y_S, 'a', es_COLOR_S);
    drawChar(es_SECOND_X + 144, es_Y_S, 'i', es_COLOR_S);
    drawChar(es_SECOND_X + 160, es_Y_S, 'n', es_COLOR_S);
    drawChar(es_SECOND_X + 176, es_Y_S, '?', es_COLOR_S);

    drawChar(es_THIRD_X, es_Y_T, 'h', es_COLOR_T);
    drawChar(es_THIRD_X + 16, es_Y_T, 'i', es_COLOR_T);
    drawChar(es_THIRD_X + 32, es_Y_T, 't', es_COLOR_T);
    drawChar(es_THIRD_X + 48, es_Y_T, '-', es_COLOR_T);
    drawChar(es_THIRD_X + 64, es_Y_T, 'l', es_COLOR_T);
    drawChar(es_THIRD_X + 80, es_Y_T, 'e', es_COLOR_T);
    drawChar(es_THIRD_X + 96, es_Y_T, 'v', es_COLOR_T);
    drawChar(es_THIRD_X + 112, es_Y_T, 'e', es_COLOR_T);
    drawChar(es_THIRD_X + 128, es_Y_T, 'l', es_COLOR_T);
    drawChar(es_THIRD_X + 144, es_Y_T, ':', es_COLOR_T);

    drawNumber(es_THIRD_X + 160, es_Y_T, score, es_COLOR_T);
}
