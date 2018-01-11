#include "Type.h"

//------------------------------------------------------------------------
struct Type
{
	File variables;
	File fonctions;
	Text nom;
	Type parent;
	bool primi;
};
//------------------------------------------------------------------------
Type 		createType(File varia , File func , Text name , Type mere, bool primitif){
	Type t = (Type)malloc(sizeof(struct Type));
	t->variables = varia;
	t->fonctions = func;
	t->nom = name;
	t->parent = mere;
	t->primi = primitif;

	return t;
}	
//------------------------------------------------------------------------
void 		freeType(Type* pSurType){
	freeFile(&((*pSurType)->variables));
	freeFile(&((*pSurType)->fonctions));
	freeText(&((*pSurType)->nom));
	free(*pSurType);
	(*pSurType) = NULL;
}

//------------------------------------------------------------------------
bool		isMyNameType(Type t , Text name){
	return isEgalText(t->nom,name);
}
//------------------------------------------------------------------------
Var         createVarWithType(Type t,Text nomVar){
	if(t->primi){
		return createVar(t,nomVar,NULL);
	}
	return createVar(t,nomVar,cloneFile(t->variables));
}
//------------------------------------------------------------------------
bool		isPrimitif(Type t){
	return t->primi;
}