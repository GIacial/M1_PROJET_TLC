#include "PileVar.h"
#include "Pile.h"
struct PileVar {
	Pile variables;
};

//------------------------------------------------------------------------

PileVar createPileVar(){
	PileVar myPile = (PileVar)malloc(sizeof(struct PileVar));
	myPile->variables = createPile();
	return myPile;
}

//------------------------------------------------------------------------

void freePileVar(PileVar* ptr){
	if(!emptyPile((*ptr)->variables)){
		Iterator i = getIteratorPile((*ptr)->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			freeVar(&v);
		}
		freeIterator(&i);
		freePile(&((*ptr)->variables));
	}
	free(*ptr);
	(*ptr) = NULL;
}

//------------------------------------------------------------------------

void addVarInPileVar(PileVar p, Var v){
	addPile(p->variables,v);
}

//------------------------------------------------------------------------

void delVarInPileVar(PileVar p, Text nom){
	Pile copy = createPile();
	bool trouve = false;
	while(!trouve && !emptyPile(p->variables)){
		if(isMyNameVar(getHeadPile(p->variables),nom)){
			trouve = true;
		}else{
			addPile(copy,getHeadPile(p->variables));
		}
		removeHeadPile(p->variables);
	}
	while(!emptyPile(copy)){
		addPile(p->variables,getHeadPile(copy));
		removeHeadPile(copy);
	}

	freePile(&copy);
}

//------------------------------------------------------------------------


Var getVarInPileVar(PileVar p,Text nom){
	if(!emptyPile((p)->variables)){
		Iterator i = getIteratorPile((p)->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			if(isMyNameVar(v,nom)){
				freeIterator(&i);
				return v;
			}
		}
		freeIterator(&i);
	}
	return NULL;
}