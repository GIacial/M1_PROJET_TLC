#include "Var.h"

//------------------------------------------------------------------------
struct Var {
	Text nom;
	void* val; 		// Pour les types primitifs
	File variables; // Pour les objets complexes
	Type type;
};
//------------------------------------------------------------------------

Var createVar(Type t , Text nom , File variables){
	Var res = (Var)malloc(sizeof(struct Var));
	res->nom = nom;
	res->type = t;
	res->val = NULL;
	res->variables = variables;
	return res;
}

//------------------------------------------------------------------------
void freeVar(Var* pSurVar){
	freeText(&((*pSurVar)->nom));
	if((*pSurVar)->val !=NULL){
		free((*pSurVar)->val);
	}
	if(!emptyFile((*pSurVar)->variables)){
		Iterator i = getIteratorFile((*pSurVar)->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			freeVar(&v);
		}
		freeIterator(&i);
		freeFile(&((*pSurVar)->variables));
	}
	freeType(&((*pSurVar)->type));
	free(*pSurVar);
	(*pSurVar) = NULL;
}

//------------------------------------------------------------------------

Type getTypeVar(Var v) {
	return v->type;
}

//------------------------------------------------------------------------

void* 	getValueVar(Var v){
	return v->val;
}

//------------------------------------------------------------------------

Var  getVarInVar(Var v , Text nomVar){
	if(!emptyFile((*pSurVar)->variables)){
		Iterator i = getIteratorFile(v->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			if(isEgalText(nomVar,v->nom)){
				freeIterator(&i);
				return v;
			}
		}
		freeIterator(&i);
		return NULL;
	}
}

//------------------------------------------------------------------------

bool  isMyNameVar(Var v,Text nom){
	return isEgalText(nom,v->nom);
}

//------------------------------------------------------------------------

Text getNameVar(Var v){
	return v->nom;
}

//------------------------------------------------------------------------
void* appFonctionVar(Var t, Text nom ,File param,Type retour){
	return appFonctionType(t->type,nom,param,retour,t);
}