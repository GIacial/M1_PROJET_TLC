#ifndef INCLUDE_PILEVAR_H
#define INCLUDE_PILEVAR_H


#include <stdlib.h>
#include <stdbool.h>
#include "Text.h"
#include "Var.h"

typedef struct PileVar* PileVar;


PileVar createPileVar();   							// creer la pile
void 	freePileVar(PileVar* ptr); 					// free la pile
void 	addVarInPileVar(PileVar p, Var v);			// Ajoute la variable à la pile
void 	delVarInPileVar(PileVar p, Text nom); 		// Supprime la variable possédant ce nom
Var 	getVarInPileVar(PileVar p,Text nom); 		// Renvoie la variable possédant ce nom


#endif //INCLUDE_PILEVAR_H