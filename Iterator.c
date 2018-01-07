#include "Iterator.h"

//-------------------------------------------------
struct Iterator
{
	Cellule c;
};
//-------------------------------------------------
Iterator 	createIterator 	(Cellule depart){
	Iterator i = (Iterator) malloc(sizeof(struct Iterator));
	i->c = depart;
	return i;
}
//-------------------------------------------------
void		freeIterator	(Iterator* pSurIterateur){
	free(*pSurIterateur);
	(*pSurIterateur) = NULL;
}
//-------------------------------------------------
bool		hasNextIterator(Iterator i){
	return isCell(i->c);
}
//-------------------------------------------------
void*		nextDataIterator(Iterator i){
	void* data = getDataCellule(i->c);
	i->c = getNextCellule(i->c);
	return data;
}