#include "Couple.h"

//----------------------------------------
struct Couple
{
	void* f;
	void* s;
};
//----------------------------------------
Couple  createCouple(void* f , void* s){
	Couple r = (Couple)malloc(sizeof (struct Couple));
	r->f = f;
	r->s = s;
	return r;
}
//----------------------------------------
void    freeCouple(Couple* pSurCouple){
	free(*pSurCouple);
	(*pSurCouple) = NULL;
}
//----------------------------------------

void*	getFirstDataCouple(Couple r){
	return r->f;
}
//----------------------------------------
void* 	getSecondDataCouple(Couple r){
	return r->s;
}
//----------------------------------------