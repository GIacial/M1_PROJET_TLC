#include "N_Uplet.h"
#include "Var.h"
#include <stdio.h>
//---------------------------------------------------------
struct N_Uplet
{
	File varlist;
	bool reel ;
};
//---------------------------------------------------------
N_Uplet 	createNUplet(File varlist, bool reel){
	N_Uplet r =(N_Uplet)malloc(sizeof(struct N_Uplet));
	r->varlist = varlist;
	r->reel = reel;
	return r;
}
//---------------------------------------------------------
void 		freeNUplet(N_Uplet* pSN){
	Iterator i = getIteratorNUplet(*pSN);
	while(hasNextIterator(i)){
		Var v = (Var) nextDataIterator(i);
		if(isMyNameVarWithChar(v,"")){//supprime var tmp
			
			freeVar(&v);

		}
	}

	freeIterator(&i);
	freeFile(&((*pSN)->varlist));

	free(*pSN);
	(*pSN) = NULL;
}

//---------------------------------------------------------
Iterator 	getIteratorNUplet(N_Uplet n ){
	return getIteratorFile(n->varlist);
}
//---------------------------------------------------------
bool		affectationNUplet(N_Uplet cible , N_Uplet contenu){
	bool ok = getSizeFile(cible->varlist) == getSizeFile(contenu->varlist);
	Iterator ci = getIteratorNUplet(cible);
	Iterator co = getIteratorNUplet(contenu);
	while(hasNextIterator(ci) && ok){
		Var vi = nextDataIterator(ci);
		Var vo = nextDataIterator(co);
		if(getTypeVar(vi) == getTypeVar(vo)){
			copieVarInVar(vi,vo);
		}
		else{
			ok = false;
		}
	}

	freeIterator(&ci);
	freeIterator(&co);
	return ok;

}
//---------------------------------------------------------
unsigned int getSizeNUplet(N_Uplet n){
	return getSizeFile(n->varlist);
}
//--------------------------------------------------------
bool isReelNUplet(N_Uplet n){
	return n->reel;
}