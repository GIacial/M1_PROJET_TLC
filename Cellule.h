#ifndef DEFINE_CELLULE_H
#define DEFINE_CELLULE_H

#include <stdlib.h>
#include <stdbool.h>

//type
struct Cellule;
typedef struct Cellule* Cellule;

//les fonctions
Cellule createCellule(void* data , Cellule suiv);		//créé la cell//le data est a free par l'utilisateur
void 	freeCellule(Cellule* pSurCellule);				//delete la cell
void*	getDataCellule(Cellule cell);							//donne la data
Cellule getNextCellule(Cellule cell);							//donne la suiv
bool	hasNextCellule(Cellule cell);							//permet de savoir si il y a un suivant
bool	isCell(Cellule cell);							//permet de savoir si la cell est vraiment une cell
void	insertAfterCellule(Cellule cell,Cellule insert);		//insert une cellule apres cell//attention inset doit avoir une suivant qui n'est pas une cell

#endif //DEFINE_CELLULE_H