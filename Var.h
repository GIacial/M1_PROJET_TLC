#ifndef INCLUDE_VAR_H
#define INCLUDE_VAR_H

#include <stdlib.h>
#include <stdbool.h>
#include "Text.h"
#include "File.h"

typedef struct Var * Var;

#include "Type.h"

Var createVar(Type t , Text nom , File variables);	//constructeur
void freeVar(Var* pSurVar);							//free	

Type 	getTypeVar(Var v);							//donne le type de la variable
void* 	getValueVar(Var v);							//donne la valeur de la variable
Var   	getVarInVar(Var v , Text nomVar);			//donne la variable qui possede ce nom dans cette variable
bool  	isMyNameVar(Var v,Text nom);				//donne si c'est le nom de la var			
Text	getNameVar(Var v);							//donne le nom(pas de copie)
void* 	appFonctionVar(Var t, Text nom ,File param,Type retour) // lance la fonction

#endif