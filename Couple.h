#ifndef INCLUDE_COUPLE_H
#define INCLUDE_COUPLE_H

#include <stdlib.h>

typedef struct Couple* Couple;

Couple  createCouple(void* f , void* s);
void    freeCouple(Couple* pSurCouple);

void*	getFirstDataCouple(Couple r);
void* 	getSecondDataCouple(Couple r);

#endif// INCLUDE_COUPLE_H