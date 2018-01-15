#include "Var.h"
#include <stdio.h>

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

void setValue(Var v, void* val ){
	if(v->val != NULL){
		free(val);
	}
	v->val = val;
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
	if(!emptyFile(v->variables)){
		Iterator i = getIteratorFile(v->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			if(isEgalText(nomVar,v->nom)){
				freeIterator(&i);
				return v;
			}
		}
		freeIterator(&i);
		
	}
	return NULL;

}

//------------------------------------------------------------------------

bool  isMyNameVar(Var v,Text nom){
	return isEgalText(nom,v->nom);
}

//------------------------------------------------------------------------

bool  isMyNameVarWithChar(Var v,const char* nom){
	return isEgalTextWithChar(v->nom, nom);
}

//------------------------------------------------------------------------

Text getNameVar(Var v){
	return v->nom;
}

//------------------------------------------------------------------------
void* appFonctionVar(Var t, Text nom ,File param,Type retour){
	return appFonctionType(t->type,nom,param,retour,t);
}

//------------------------------------------------------------------------

bool copieVarInVar(Var cible ,Var contenu){

	if(cible->type == contenu->type){
		cible->val = contenu->val;
		clearFile(cible->variables);
		if(!emptyFile(contenu->variables)){
			Iterator i = getIteratorFile(contenu->variables);
			while(hasNextIterator(i)){
				addFile(cible->variables,nextDataIterator(i));
			}
			freeIterator(&i);
		}
		return true;

	}else{
		return false;
	}
}

//------------------------------------------------------------------------
void afficheVar(Var v){

	afficheText(v->nom);

	if(v->val !=NULL){ // variable primitives
		if(isMyNameTypeWithChar(v->type,"int")){
			printf("%d",(int)v->val);
		}else if(isMyNameTypeWithChar(v->type,"float")){
			printf("%f",(float)v->val);
		}else if(isMyNameTypeWithChar(v->type,"bool")){
			if(v->var){
				printf("true");
			}else{
				printf("false");
			}
		}else {
			fprintf(stderr, "Type primitif non trouve");
		}

	}else if(!emptyFile(v->variables)){ // variables objets
		printf("( ");
		Iterator i = getIteratorFile(v->variables);
		while(hasNextIterator(i)){
			afficheVar((Var)nextDataIterator(i));
			printf(", ");
		}
		freeIterator(&i);
		printf(" )");
	}else {
		fprintf(stderr,"Erreur Affichage valeur");
	}
}
