#ifndef INCLUDE_PILE_H
#define INCLUDE_PILE_H

#include <stdlib.h>
#include <stdbool.h>
#include "Iterator.h"

//type
struct Pile;
typedef struct Pile * Pile;

//fonction
Pile 	 createPile();						//permet de créé une pile
void 	 freePile(Pile* pSurPile);			//permet de free la pile
void 	 addPile(Pile p , void* data);		//ajoute data à la pile
void*	 getHeadPile(Pile p);				//la donné à la tete de la pile
void	 removeHeadPile(Pile p);				//eneleve la tete
bool     emptyPile(Pile p);					//permet de savoir si la pile est vide
Iterator getIteratorPile(Pile p);				//donne un iterator sur la pile
void	 clearPile(Pile p);						//vide la pile

#endif //INCLUDE_PILE_H