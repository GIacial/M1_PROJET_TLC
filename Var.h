#ifndef INCLUDE_VAR_H
#define INCLUDE_VAR_H

#include <stdlib.h>
#include <stdbool.h>
#include "Text.h"
#include "File.h"

typedef struct Var * Var;

#include "Type.h"
#include "N_Uplet.h"

Var createVar(Type t , Text nom , File variables);	//constructeur
void freeVar(Var* pSurVar);							//free	

void 	setValue(Var v, void* val ); 				// ajoute une valeur à la variable (si primitif)
Type 	getTypeVar(Var v);							//donne le type de la variable
void* 	getValueVar(Var v);							//donne la valeur de la variable
Var   	getVarInVar(Var v , Text nomVar);			//donne la variable qui possede ce nom dans cette variable
bool  	isMyNameVar(Var v,Text nom);				//donne si c'est le nom de la var	
bool  	isMyNameVarWithChar(Var v,const char* nom);	 // donne si c'est le nom de la var
Text	getNameVar(Var v);							//donne le nom(pas de copie)
N_Uplet 	appFonctionVar(Var t, Text nom ,File param); // lance la fonction
bool	isMyFonctionVar(Var v ,Text nom ,File param );//verif l'existance de la fonction
bool	copieVarInVar(Var cible ,Var contenu);							//verif type des deux puis copie les data de l'un vers l'autre
void 	afficheVar(Var v); 							// affiche la variable
bool 	affectationVarWithNUplet(Var cible,N_Uplet contenu);	//affectation avec un nuplet
N_Uplet getNUpletVar(Var v);								//donne le n-uplet contenant les champs de la var

#endif