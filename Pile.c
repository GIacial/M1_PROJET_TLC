#include "Pile.h"

//------------------------------------------------------
struct Pile
{
	unsigned int size;
	Cellule head;
};
//------------------------------------------------------
Pile 	 createPile(){
	Pile p = (Pile) malloc (sizeof(struct Pile));
	p->size = 0;
	p->head = NULL;
	return p;
}
//------------------------------------------------------
void 	 freePile(Pile* pSurPile){
	clearPile(*pSurPile);
	free (*pSurPile);
	(*pSurPile) = NULL;
}
//------------------------------------------------------
void 	 addPile(Pile p , void* data){
	p->head = createCellule(data,p->head);
	p->size ++;
}
//------------------------------------------------------
void*	 getHeadPile(Pile p){
	return getDataCellule(p->head);
}
//------------------------------------------------------
void	 removeHeadPile(Pile p){
	Cellule c = p->head;
	p->head = getNextCellule(c);
	free(c);
	p->size -- ;
}
//------------------------------------------------------
bool     emptyPile(Pile p){
	return !isCell(p->head);
}
//------------------------------------------------------
Iterator getIteratorPile(Pile p){
	return createIterator(p->head);
}
//------------------------------------------------------
void	 clearPile(Pile p){
	while(!emptyPile(p)){
		removeHeadPile(p);
	}
}
