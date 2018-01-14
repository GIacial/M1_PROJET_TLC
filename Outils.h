#ifndef INCLUDE_OUTILS_H
#define INCLUDE_OUTILS_H

#include "Var.h"
enum Operation {
	OPERATION_PLUS,OPERATION_MOINS,OPERATION_MULTI,OPERATION_DIV
};

Var operationVar(Var v1,Var v2 ,enum Operation o);		//fait les verif et l'operation
Var intOperation(int v1 , int v2 , enum Operation o ,Type t);	//fais op sur int
Var floatOperation(float v1 , float v2 , enum Operation o, Type t);	//op sur float


#endif //INCLUDE_OUTILS_H