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
	//ajout des fonction value et print
	addFile(t->fonctions,createFonction(createText("value"),createFile(),NULL));
	addFile(t->fonctions,createFonction(createText("print"),createFile(),NULL));
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
		Fonction v = (Fonction)nextDataIterator(i);
		freeFonction(&v);
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
bool		isMyNameTypeWithChar(Type t , const char* name){
	return isEgalTextWithChar(t->nom,name);
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
bool		isPrimitifType(Type t){
	return t->primi;
}
//------------------------------------------------------------------------
N_Uplet 		appFonctionType(Type t, Text nom ,File param,Var val){
	Iterator i = getIteratorFile(t->fonctions);
	bool ok = false;
	N_Uplet rs = NULL;
	while(!ok && hasNextIterator(i)){
		Fonction f = (Fonction)nextDataIterator(i);
		ok = isMeFonction(f,nom,param);
		if(ok){
			rs = exec(f,param,val);
		}
	}
	freeIterator (&i);
	if(!ok && t->parent!=NULL){
		rs = appFonctionType(t->parent,nom,param,val);
	}
	return rs;
}
//------------------------------------------------------------------------
bool		isMyParentType(Type t , Type p){
	bool ok = t == p;
	if(t->parent != NULL && !ok){		
		 ok = t->parent == p;
		if(!ok){
			isMyParentType(t->parent,p);
		}
	}
	return ok;

}
//------------------------------------------------------------------------
bool		isMyFonctionType(Type t,Text nom ,File param ){
	Iterator i = getIteratorFile(t->fonctions);
	bool ok = false;
	while(!ok && hasNextIterator(i)){
		Fonction f = (Fonction)nextDataIterator(i);
		ok = isMeFonction(f,nom,param);
	}
	freeIterator (&i);
	if(!ok && t->parent!=NULL){
		ok = isMyFonctionType(t->parent,nom,param);
	}
	return ok;
}