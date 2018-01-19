#include "Fonction.h"
#include <stdio.h>
//----------------------------------------------------------
struct Fonction
{
	Text nom;
	File param;
	Type retour;
};
//----------------------------------------------------------
Fonction 	createFonction(Text nom , File param, Type retour){
	Fonction f = (Fonction) malloc(sizeof(struct Fonction));
	f->nom = nom;
	f->param = param;
	f->retour = retour;
	return f;
}
//----------------------------------------------------------
void		freeFonction(Fonction* pSurFonction){
	free((*pSurFonction)->nom);
	Iterator i = getIteratorFile((*pSurFonction)->param);
	while(hasNextIterator(i)){
		Var v = nextDataIterator(i);
		freeVar(&v);
	}
	freeIterator(&i);
	freeFile(&((*pSurFonction)->param));
	//pas de delete du type car contenu dans la table des var
	free(*pSurFonction);
	(*pSurFonction) = NULL;
}
//----------------------------------------------------------
bool		isMeFonction(Fonction f , Text nom , File param){
	bool ok = isEgalText(f->nom,nom) && getSizeFile(param) == getSizeFile(f->param);
	Iterator i = getIteratorFile(f->param);
	Iterator j = getIteratorFile(param);
	while (ok && hasNextIterator(i) && hasNextIterator(j)){
		Var vi = (Var)nextDataIterator(i);
		Var vj = (Var)nextDataIterator(j);
		ok = getTypeVar(vi) == getTypeVar(vj);
	}
	freeIterator(&i);
	freeIterator(&j);
	return ok;
}
//----------------------------------------------------------
Type 		getRTypeFonction(Fonction f){
	return f->retour;
}
//----------------------------------------------------------
Var		exec(Fonction f,File param,Var v){
	if(isEgalTextWithChar(f->nom,"print")){
		afficheVar(v);
	}
	else{
		if(isEgalTextWithChar(f->nom,"value")){
			return NULL;	//return n-uplet
		}
		else{
			fprintf(stderr, "Pas fait pour le moment\n" );
		}
	}
	return NULL;
}
//----------------------------------------------------------