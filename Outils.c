#include "Outils.h"


//----------------------------------------------
Var operationVar(Var v1,Var v2 ,enum Operation o){
	Var res = NULL;
	if(getTypeVar(v1) == getTypeVar(v2)){
		Type t = getTypeVar(v1);
		Text c = createText("int");
		if(isMyNameType(t,c)){
			//cas int
			res = intOperation(*((int*)getValueVar(v1)),*((int*)getValueVar(v2)),o,getTypeVar(v1));
		}
		else{
			Text f = createText("float");
			if(isMyNameType(t,f)){
				//cas float
				res = floatOperation(*((float*)getValueVar(v1)),*((float*)getValueVar(v2)),o,getTypeVar(v1));
			}
			freeText(&f);
		}
		freeText(&c);
	}
	//nettoyage de v1 et v2 si tmp (tmp => nom =="")
	Text n = createText("");
	if(isMyNameVar(v1,n)){
		freeVar(&v1);
	}
	if(isMyNameVar(v2,n)){
		freeVar(&v2);
	}
	freeText(&n);
	return res;
}
//----------------------------------------------

Var intOperation(int v1 , int v2 , enum Operation o , Type t){
	Var v = createVarWithType(t,createText(""));
	int* p = (int*) malloc(sizeof(int));
	switch(o){
		case OPERATION_PLUS :	(*p) = v1 + v2;setValue(v,p);
			break;
		case OPERATION_MOINS : (*p) = v1 - v2;setValue(v,p);
			break;
		case OPERATION_MULTI : (*p) = v1 * v2;setValue(v,p);
			break;
		case OPERATION_DIV : (*p) = v1 / v2;setValue(v,p);
			break;
		default: freeVar(&v);free(p); p = NULL;
			break;
	}
	return v;
}
//----------------------------------------------
Var floatOperation(float v1 , float v2 , enum Operation o, Type t){
	Var v = createVarWithType(t,createText(""));
	float* p = (float*) malloc(sizeof(float));
	switch(o){
		case OPERATION_PLUS :	(*p) = v1 + v2;setValue(v,p);
			break;
		case OPERATION_MOINS : (*p) = v1 - v2;setValue(v,p);
			break;
		case OPERATION_MULTI : (*p) = v1 * v2;setValue(v,p);
			break;
		case OPERATION_DIV : (*p) = v1 / v2;setValue(v,p);
			break;
		default: freeVar(&v);free(p); p = NULL;
			break;
	}
	return v;
}
//----------------------------------------------