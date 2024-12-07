#include "../utils.h"

int main()
{

    char sp = 0;
    do
    {
        sp = getSPART();
        if (sp == 'a')
        {
            setSPART('z');
        }
        else if (sp == 'b')
        {
            setSPART('y');
        }
        else if (sp == 'c')
        {
            setSPART('x');
        }
        else if (sp == 'd')
        {
            setSPART('w');
        }
        else if (sp == 'e')
        {
            setSPART('v');
        }
        else if (sp == 'f')
        {
            setSPART('u');
        }
        else if (sp == 'g')
        {
            setSPART('t');
        }
        else if (sp == 'h')
        {
            setSPART('s');
        }
        else if (sp == 'i')
        {
            setSPART('r');
        }
        else if (sp == 'j')
        {
            setSPART('q');
        }
        else if (sp == 'k')
        {
            setSPART('p');
        }
        else if (sp == 'l')
        {
            setSPART('o');
        }
        else if (sp == 'm')
        {
            setSPART('n');
        }
        else if (sp == 'n')
        {
            setSPART('m');
        }
        else if (sp == 'o')
        {
            setSPART('l');
        }
        else if (sp == 'p')
        {
            setSPART('k');
        }
        else if (sp == 'q')
        {
            setSPART('j');
        }
        else if (sp == 'r')
        {
            setSPART('i');
        }
        else if (sp == 's')
        {
            setSPART('h');
        }
        else if (sp == 't')
        {
            setSPART('g');
        }
        else if (sp == 'u')
        {
            setSPART('f');
        }
        else if (sp == 'v')
        {
            setSPART('e');
        }
        else if (sp == 'w')
        {
            setSPART('d');
        }
        else if (sp == 'x')
        {
            setSPART('c');
        }
        else if (sp == 'y')
        {
            setSPART('b');
        }
        else if (sp == 'z')
        {
            setSPART('a');
        }
    } while (sp != 'q');

end:
    goto end;

    return 0;
}