#include "NoeudArbre.h"

//----------------------------------------------------
struct NoeudArbre
{
	NoeudArbre g;
	NoeudArbre d;
};
//----------------------------------------------------
NoeudArbre 	createNoeudArbre(NoeudArbre g, NoeudArbre d){
	NoeudArbre r = (NoeudArbre)malloc(sizeof(struct NoeudArbre));
	r->g = g;
	r->d = d;
	return d;
}
//----------------------------------------------------
void 		freeNoeudArbre(NoeudArbre* pSA){
	if((*pSA)->g != NULL){
		freeNoeudArbre(&((*pSA)->g));
	}
	if((*pSA)->d != NULL){
		freeNoeudArbre(&((*pSA)->d));
	}
	free(*pSA);
	(*pSA) = NULL;
}
//----------------------------------------------------
N_Uplet 	execNoeudArbre(NoeudArbre r){
	return NULL;
}
//----------------------------------------------------

//----------------------------------------------------
