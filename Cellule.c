#include "Cellule.h"

//--------------------------------------------------------
struct Cellule
{
	void* data;
	struct Cellule* suiv;
	
};
//--------------------------------------------------------
Cellule createCellule(void* data , Cellule suiv){
	Cellule c = (Cellule) malloc(sizeof(struct Cellule));
	c->data = data;
	c->suiv = suiv;
	return c;
}
//--------------------------------------------------------
void 	freeCellule(Cellule* pSurCellule){
	free(*pSurCellule);
	(*pSurCellule) = NULL;
}
//--------------------------------------------------------
void*	getDataCellule(Cellule cell){
	return cell->data;
}
//--------------------------------------------------------
Cellule getNextCellule(Cellule cell){
	return cell->suiv;
}
//--------------------------------------------------------
bool	hasNextCellule(Cellule cell){
	return isCell(cell->suiv);
}
//--------------------------------------------------------
bool	isCell(Cellule cell){
	return cell != NULL;
}
//--------------------------------------------------------
void	insertAfterCellule(Cellule cell,Cellule insert){
	Cellule next = getNextCellule(cell);
	cell->suiv = insert;
	insert->suiv = next;
}
