#include "Fonction.h"

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
bool		isMeFonction(Fonction f , Text nom , File param, Type retour){
	bool ok = isEgalText(f->nom,nom) && getSizeFile(param) == getSizeFile(f->param)
				&& f->retour == retour;
	Iterator i = getIteratorFile(f->param);
	Iterator j = getIteratorFile(param);
	while (ok && hasNextIterator(i) && hasNextIterator(j)){
		Var vi = (Var)nextDataIterator(i);
		Var vj = (Var)nextDataIterator(j);
		ok = isSameVar(vi, vj);
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
void*		exec(Fonction f,File param){
	return NULL;
}
//----------------------------------------------------------