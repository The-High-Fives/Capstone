#include "../utils.h"

int main()
{

    char sp = 0;
    do
    {
        sp = getSPART();
        if (sp == 'a')
        {
            setSpart('z');
        }
        else if (sp == 'b')
        {
            setSpart('y');
        }
        else if (sp == 'c')
        {
            setSpart('x');
        }
        else if (sp == 'd')
        {
            setSpart('w');
        }
        else if (sp == 'e')
        {
            setSpart('v');
        }
        else if (sp == 'f')
        {
            setSpart('u');
        }
        else if (sp == 'g')
        {
            setSpart('t');
        }
        else if (sp == 'h')
        {
            setSpart('s');
        }
        else if (sp == 'i')
        {
            setSpart('r');
        }
        else if (sp == 'j')
        {
            setSpart('q');
        }
        else if (sp == 'k')
        {
            setSpart('p');
        }
        else if (sp == 'l')
        {
            setSpart('o');
        }
        else if (sp == 'm')
        {
            setSpart('n');
        }
        else if (sp == 'n')
        {
            setSpart('m');
        }
        else if (sp == 'o')
        {
            setSpart('l');
        }
        else if (sp == 'p')
        {
            setSpart('k');
        }
        else if (sp == 'q')
        {
            setSpart('j');
        }
        else if (sp == 'r')
        {
            setSpart('i');
        }
        else if (sp == 's')
        {
            setSpart('h');
        }
        else if (sp == 't')
        {
            setSpart('g');
        }
        else if (sp == 'u')
        {
            setSpart('f');
        }
        else if (sp == 'v')
        {
            setSpart('e');
        }
        else if (sp == 'w')
        {
            setSpart('d');
        }
        else if (sp == 'x')
        {
            setSpart('c');
        }
        else if (sp == 'y')
        {
            setSpart('b');
        }
        else if (sp == 'z')
        {
            setSpart('a');
        }
    } while (sp != 'q');

end:
    goto end;

    return 0;
}