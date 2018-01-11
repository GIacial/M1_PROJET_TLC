#ifndef INCLUDE_TEXT_H
#define INCLUDE_TEXT_H

#include <stdlib.h>
#include <stdbool.h>

typedef struct Text* Text;

Text createText(char* texte);
void freeText(Text* pSurText);

unsigned int sizeofText(Text t);
bool isEgalText(Text t1 , Text t2);

#endif