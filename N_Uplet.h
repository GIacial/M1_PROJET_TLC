#ifndef INCLUDE_N_UPLET_H
#define INCLUDE_N_UPLET_H

#include <stdlib.h>
#include <stdbool.h>

typedef struct N_Uplet* N_Uplet;

#include "Iterator.h"
#include "File.h"

N_Uplet 	createNUplet(File varlist, bool reel);
void 		freeNUplet(N_Uplet* pSN);

Iterator 	getIteratorNUplet(N_Uplet n );
bool		affectationNUplet(N_Uplet cible , N_Uplet contenu);		//affectele contenu dans cible
unsigned int getSizeNUplet(N_Uplet n);
bool		isReelNUplet(N_Uplet n);


#endif //INCLUDE_N_UPLET_H