#ifndef INCLUDE_ITERATOR_H
#define INCLUDE_ITERATOR_H

#include <stdlib.h>
#include <stdbool.h>
#include "Cellule.h"

//type
typedef struct Iterator* Iterator;

//fonction
Iterator 	createIterator 	(Cellule depart);				//cree l'iterator
void		freeIterator	(Iterator* pSurIterateur);		//delete l'iterator
bool		hasNextIterator(Iterator i);							//permet de savoir si il y a une suite
void*		nextDataIterator(Iterator i);							//donne le suivant		

#endif //INCLUDE_ITERATOR_H