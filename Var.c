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
	else{//pas primitif
		if(!emptyFile((*pSurVar)->variables)){
		Iterator i = getIteratorFile((*pSurVar)->variables);
		while(hasNextIterator(i)){
			Var v = (Var)nextDataIterator(i);
			freeVar(&v);
		}
		freeIterator(&i);
		freeFile(&((*pSurVar)->variables));
		}
	}
	
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
	bool ok = false;
	if(cible->type == contenu->type){
		if(isPrimitifType(cible->type)){
			if(cible->val!= NULL){
				free(cible->val);
				cible->val = NULL;
			}
			if(isMyNameTypeWithChar(cible->type,"int")){
				cible->val = malloc(sizeof(int));
				(*(int*)cible->val) = (*(int*)contenu->val);
				ok = true;
			}else if(isMyNameTypeWithChar(cible->type,"float")){
				cible->val = malloc(sizeof(float));
				(*(float*)cible->val) = (*(float*)contenu->val);
				ok = true;
			}else if(isMyNameTypeWithChar(cible->type,"bool")){
				cible->val = malloc(sizeof(bool));
				(*(bool*)cible->val) = (*(bool*)contenu->val);
				ok = true;
			}else {
				fprintf(stderr, "Type primitif non trouve\n");
			}
		}
		else{
			//clearFile(cible->variables);	//faire del des p
			if(!emptyFile(contenu->variables)){
				Iterator i = getIteratorFile(contenu->variables);
				while(hasNextIterator(i)){
					addFile(cible->variables,nextDataIterator(i));
				}
				freeIterator(&i);
			}
			ok = true;
		}


	}
	return ok;
}

//------------------------------------------------------------------------
void afficheVar(Var v){

	afficheText(v->nom);

	if(v->val !=NULL){ // variable primitives
		if(isMyNameTypeWithChar(v->type,"int")){
			printf("%d\n",*((int*)v->val));
		}else if(isMyNameTypeWithChar(v->type,"float")){
			printf("%f\n",*((float*)v->val));
		}else if(isMyNameTypeWithChar(v->type,"bool")){
			if(*((bool*)v->val)){
				printf("true\n");
			}else{
				printf("false\n");
			}
		}else {
			fprintf(stderr, "Type primitif non trouve\n");
		}

	}else if(!emptyFile(v->variables)){ // variables objets
		printf("( ");
		Iterator i = getIteratorFile(v->variables);
		while(hasNextIterator(i)){
			afficheVar((Var)nextDataIterator(i));
			printf(", ");
		}
		freeIterator(&i);
		printf(" )\n");
	}else {
		fprintf(stderr,"Erreur Affichage valeur\n");
	}
}
