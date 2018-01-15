#ifndef INCLUDE_OUTILS_H
#define INCLUDE_OUTILS_H

#include "Var.h"
enum Operation {
	OPERATION_PLUS,OPERATION_MOINS,OPERATION_MULTI,OPERATION_DIV
};

enum BoolOperation{
	OPERATION_INF,OPERATION_SUP,OPERATION_INFEG,OPERATION_SUPEG,OPERATION_EG,OPERATION_DIFF,OPERATION_AND,OPERATION_OR
};

Var operationVar(Var v1,Var v2 ,enum Operation o);		//fait les verif et l'operation
Var intOperation(int v1 , int v2 , enum Operation o ,Type t);	//fais op sur int
Var floatOperation(float v1 , float v2 , enum Operation o, Type t);	//op sur float

Var BoolOperation(Var v1 , Var v2 , enum BoolOperation o, Type primiBool );	//fait les op Bool
Var intBoolOperation(int v1, int v2, enum BoolOperation o, Type primiBool ); //fait les op bool avec des int
Var floatBoolOperation(float v1, float v2, enum BoolOperation o, Type primiBool ); //fait les op bool avec des float
Var boolBoolOperation(bool v1, bool v2, enum BoolOperation o, Type primiBool ); //fait les op bool avec des bool


#endif //INCLUDE_OUTILS_H