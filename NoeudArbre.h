#ifndef INCLUDE_NOEUD_ARBRE_H
#define INCLUDE_NOEUD_ARBRE_H

#include <stdlib.h>
#include <stdio.h>

typedef struct NoeudArbre* NoeudArbre;

#include "N_Uplet.h"

NoeudArbre 	createNoeudArbre(NoeudArbre g, NoeudArbre d);
void 		freeNoeudArbre(NoeudArbre* pSA);

N_Uplet 	execNoeudArbre(NoeudArbre r);			//calcule la valeurs de l'arbre



#endif //INCLUDE_NOEUD_ARBRE_H