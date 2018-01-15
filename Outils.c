#include "Outils.h"
#include <stdio.h>

//----------------------------------------------
Var operationVar(Var v1,Var v2 ,enum Operation o){
	Var res = NULL;
	if(getTypeVar(v1) == getTypeVar(v2) && getValueVar(v1)!= NULL && getValueVar(v2)!= NULL){
		Type t = getTypeVar(v1);
		if(isMyNameTypeWithChar(t,"int")){
			//cas int
			res = intOperation(*((int*)getValueVar(v1)),*((int*)getValueVar(v2)),o,getTypeVar(v1));
		}
		else{
			if(isMyNameTypeWithChar(t,"float")){
				//cas float
				res = floatOperation(*((float*)getValueVar(v1)),*((float*)getValueVar(v2)),o,getTypeVar(v1));
			}
		}
	}
	//nettoyage de v1 et v2 si tmp (tmp => nom =="")
	if(isMyNameVarWithChar(v1,"")){
		freeVar(&v1);
	}
	if(isMyNameVar(v2,"")){
		freeVar(&v2);
	};
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
		default: freeVar(&v);free(p); p = NULL;fprintf(stderr,"Operation non defini\n");
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
Var BoolOperation(Var v1 , Var v2 , enum BoolOperation o, Type primiBool ){
		Var res = NULL;
	if(getTypeVar(v1) == getTypeVar(v2) && getValueVar(v1)!= NULL && getValueVar(v2)!= NULL){
		Type t = getTypeVar(v1);
		if(isMyNameTypeWithChar(t,"int")){
			//cas int
			res = intBoolOperation(*((int*)getValueVar(v1)),*((int*)getValueVar(v2)),o,getTypeVar(v1));
		}
		else{
			if(isMyNameTypeWithChar(t,"float")){
				//cas float
				res = floatBoolOperation(*((float*)getValueVar(v1)),*((float*)getValueVar(v2)),o,getTypeVar(v1));
			}
			else{
				if(isMyNameTypeWithChar(t,"bool")){
				//cas bool
				res = boolBoolOperation(*((bool*)getValueVar(v1)),*((bool*)getValueVar(v2)),o,getTypeVar(v1));
			}
			}
		}
	}
	//nettoyage de v1 et v2 si tmp (tmp => nom =="")
	if(isMyNameVarWithChar(v1,"")){
		freeVar(&v1);
	}
	if(isMyNameVar(v2,"")){
		freeVar(&v2);
	};
	return res;
}
//----------------------------------------------
Var intBoolOperation(int v1, int v2, enum BoolOperation o, Type primiBool ){
	Var v = createVarWithType(primiBool,createText(""));
	bool* p = (bool*) malloc(sizeof(bool));
	switch(o){
		case OPERATION_INF :	(*p) = v1 < v2;setValue(v,p);
			break;
		case OPERATION_INFEG : (*p) = v1 <= v2;setValue(v,p);
			break;
		case OPERATION_SUP : (*p) = v1 > v2;setValue(v,p);
			break;
		case OPERATION_SUPEG : (*p) = v1 >= v2;setValue(v,p);
			break;
		case OPERATION_EG : (*p) = v1 == v2;setValue(v,p);
			break;
		case OPERATION_DIFF : (*p) = v1 != v2;setValue(v,p);
			break;
		default: freeVar(&v);free(p); p = NULL;fprintf(stderr,"Operation non defini pour int\n");
			break;
	}
	return v;
}
//----------------------------------------------
Var floatBoolOperation(float v1, float v2, enum BoolOperation o, Type primiBool ){
		Var v = createVarWithType(primiBool,createText(""));
	bool* p = (bool*) malloc(sizeof(bool));
	switch(o){
		case OPERATION_INF :	(*p) = v1 < v2;setValue(v,p);
			break;
		case OPERATION_INFEG : (*p) = v1 <= v2;setValue(v,p);
			break;
		case OPERATION_SUP : (*p) = v1 > v2;setValue(v,p);
			break;
		case OPERATION_SUPEG : (*p) = v1 >= v2;setValue(v,p);
			break;
		case OPERATION_EG : (*p) = v1 == v2;setValue(v,p);
			break;
		case OPERATION_DIFF : (*p) = v1 != v2;setValue(v,p);
			break;
		default: freeVar(&v);free(p); p = NULL;fprintf(stderr,"Operation non defini pour float\n");
			break;
	}
	return v;
}
//----------------------------------------------
Var boolBoolOperation(bool v1, bool v2, enum BoolOperation o, Type primiBool ){
		Var v = createVarWithType(primiBool,createText(""));
	bool* p = (bool*) malloc(sizeof(bool));
	switch(o){
		case OPERATION_OR : (*p) = v1 || v2;setValue(v,p);
			break;
		case OPERATION_AND : (*p) = v1 && v2;setValue(v,p);
			break;
		case OPERATION_EG : (*p) = v1 == v2;setValue(v,p);
			break;
		case OPERATION_DIFF : (*p) = v1 != v2;setValue(v,p);
			break;
		default: freeVar(&v);free(p); p = NULL;fprintf(stderr,"Operation non defini pour bool\n");
			break;
	}
	return v;
}
//----------------------------------------------