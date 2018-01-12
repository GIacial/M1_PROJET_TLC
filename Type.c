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
	//rajout delete du contenu
	Iterator i = getIteratorFile((*pSurType)->variables);
	while(hasNextIterator(i)){
		Var v = (Var)nextDataIterator(i);
		freeVar(&v);
	}
	freeIterator(&i);
	freeFile(&((*pSurType)->variables));

	i = getIteratorFile((*pSurType)->fonctions);
	while(hasNextIterator(i)){
		Var v = (Var)nextDataIterator(i);
		freeVar(&v);
	}
	freeIterator(&i);
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
	//copie
	File r = createFile();
	Iterator i = getIteratorFile(t->variables);
	while(hasNextIterator(i)){
		Var v = (Var)nextDataIterator(i);
		addFile(r,createVarWithType(getTypeVar(v),copyText(getNameVar(v))));
	}
	freeIterator(&i);
	return createVar(t,nomVar,r);
}
//------------------------------------------------------------------------
bool		isPrimitif(Type t){
	return t->primi;
}