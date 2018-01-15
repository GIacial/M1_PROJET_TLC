#include "Text.h"
#include <string.h>
#include <stdio.h>
//------------------------------------------
struct Text
{
	char* texte;
	unsigned int size;
	
};
//------------------------------------------
Text createText(char* texte){
	Text t = (Text)malloc (sizeof(struct Text));
	//t->texte = strdup(texte);
	t->texte = (char*) malloc(strlen(texte)+1);//pour /0
	strcpy(t->texte,texte);
	t->size = (unsigned int)strlen(t->texte);
	return t;
}
//------------------------------------------
Text copyText(Text t){
	return createText(t->texte);
}
//------------------------------------------
void freeText(Text* pSurText){
	free((*pSurText)->texte);
	free(*pSurText);
	(*pSurText) = NULL;
}
//------------------------------------------
unsigned int sizeofText(Text t){
	return t->size;
}
//------------------------------------------
bool isEgalText(Text t1 , Text t2){
	return strcmp (t1->texte , t2->texte) == 0;
}

//------------------------------------------
bool isEgalTextWithChar(Text t1 , const char * t2){
	return strcmp (t1->texte , t2) == 0;
}
//------------------------------------------

void afficheText(Text t1){
	printf("%s :=",t1->texte);
}