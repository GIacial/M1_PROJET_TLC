#ifndef INCLUDE_TEXT_H
#define INCLUDE_TEXT_H

#include <stdlib.h>
#include <stdbool.h>

typedef struct Text* Text;

Text createText(char* texte);
Text copyText(Text t);
void freeText(Text* pSurText);

unsigned int sizeofText(Text t);
bool isEgalText(Text t1 , Text t2);
bool isEgalTextWithChar(Text t1,const char* t2);

void afficheText(Text t1);

#endif