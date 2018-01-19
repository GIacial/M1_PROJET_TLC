%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
	extern int yylex();
	extern int yyerror(char*);

	#include "TabType.h"
	#include "PileVar.h"
	#include "File.h"
	#include "Outils.h"
	#include "Couple.h"

	TabType type = NULL;
	PileVar var  = NULL;
%}
%token KW_CLASS 
%token<nom> IDENF
%token KW_EXTEND
%token KW_DATA
%token<nom> TYP_PRIMITIF
%token SEP_INSTRUCT
%token KW_FUNCTION
%token PAR_OUV
%token PAR_FER
%token KW_RETURN
%token FUNC_OUV
%token FUNC_FERM
%token OP_PLUS
%token OP_MOINS
%token OP_MULTI
%token OP_DIV
%token OP_AFF
%token OP_FUNC
%token OP_INF
%token OP_INF_EQ
%token OP_SUP
%token OP_SUP_EQ
%token OP_DIFF
%token OP_EQ
%token OP_AND
%token OP_OR
%token KW_ENDCLASS
%token<valBool> VAL_BOOL
%token<valInt> VAL_INT
%token<valFloat> VAL_FLOAT
%token SEP_PARAM

%left OP_OR 
%left OP_AND
%left OP_EQ OP_DIFF OP_INF OP_SUP OP_INF_EQ OP_SUP_EQ
%left OP_PLUS OP_MOINS
%left OP_MULTI OP_DIV

%start prog

%type<variable> valeurs
%type<variable> expNum
%type<variable> expComp
%type<variable> expression
%type<uplet> instructionReturn
%type<typeVar>  type
%type<file> 	valList
%type<pair>		enteteClass
%type<pair>		contenuClass
%type<file> 	data
%type<file>		declaFunction
%type<variable>  declaVarClass
%type<file> 	parametreDecla
%type<pair> 	corpsFunction
%type<file> 	parametre
%type<variable> methodAppelReturn
%type<uplet> 	nUplet

%union{
	Text 	nom;
	int 	valInt;
	float 	valFloat;
	bool 	valBool;
	Var 	variable;
	Type    typeVar;
	File 	file;
	Couple  pair;
	N_Uplet uplet;
}
%%

prog			:bloc  prog															
				|bloc 																{YYACCEPT;}
				;

bloc		: class 																
			|instruction SEP_INSTRUCT												
			;

class 		:enteteClass contenuClass KW_ENDCLASS									{Text nomType = getFirstDataCouple($1);
																					 Type mere 	= getSecondDataCouple($1);
																					 File data  = getFirstDataCouple($2);
																					 File fonction = getSecondDataCouple($2);
																					 Couple a = $1;
																					 Couple b = $2;
																					 freeCouple(&a);
																					 freeCouple(&b);
																					 addTypeInTabType(type,createType(data,fonction,nomType,mere,false));
																					}
			;

enteteClass	:KW_CLASS IDENF															{$$ = createCouple($2,NULL);}
			|KW_CLASS IDENF KW_EXTEND IDENF											{Type mere = getTypeInTabType(type,$4);
																					 Text tm = $4;
																					 freeText(&tm);
																					 if(mere == NULL){
																					 	fprintf(stderr,"Erreur sémantique (enteteClass : type mere non trouvé)\n");
																					 	return -1;
																					 }
																					 if(isPrimitifType(mere)){//normalement pas possible grace au lex
																					 	fprintf(stderr,"Erreur sémantique (enteteClass : type mere primitif)\n");
																					 	return -1;
																					 }
																					 $$ = createCouple($2,mere);
																					}
			;

contenuClass:KW_DATA data KW_FUNCTION declaFunction 								{$$ = createCouple($2,$4);}
			|KW_DATA  KW_FUNCTION declaFunction 									{$$ = createCouple(createFile(),$3);}
			|KW_DATA data KW_FUNCTION  												{$$ = createCouple($2,createFile());}
			;

data      	:declaVarClass SEP_INSTRUCT data 											{addFile($3,$1); $$ = $3;}
			|declaVarClass SEP_INSTRUCT  												{File f = createFile(); addFile(f,$1); $$ = f;}
			;

declaVarClass:type IDENF															{$$ = createVarWithType($1,$2);}
			;

declaVar	:type IDENF																{addVarInPileVar(var,createVarWithType($1,$2));}
			;

type 		:TYP_PRIMITIF															{Type a = getTypeInTabType(type,$1);
																					 Text t = $1;
																					 freeText(&t);
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : primitif non trouvé)\n");
																					 	return -1;
																					 }
																					 $$ = a;
																					}
			|IDENF																	{Type a = getTypeInTabType(type,$1);
																					 Text t = $1;
																					 freeText(&t);
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type :type non trouvé)\n");
																					 	return -1;
																					 }
																					 $$ = a;
																					}
			;

declaFunction:IDENF parametreDecla corpsFunction SEP_INSTRUCT declaFunction 		{addFile($5,createFonction($1,$2,getSecondDataCouple($3))) ;
																					 Couple a = $3;
																					 freeCouple(&a);
																					  $$ = $5;}
			|IDENF parametreDecla corpsFunction SEP_INSTRUCT						{File f = createFile();
																					 addFile(f,createFonction($1,$2,getSecondDataCouple($3)/*type r*/)) ;
																					 Couple a = $3;
																					 freeCouple(&a);
																					  $$ = f;
																					}	
			;


parametreDecla	:PAR_OUV parametre PAR_FER											{$$ = $2;}
				|PAR_OUV PAR_FER													{$$ = createFile();}
			;

parametre 	:declaVarClass SEP_PARAM parametre 											{ addFile($3,$1); $$ =$3;}
			|declaVarClass																{File f = createFile(); addFile(f,$1); $$ =f;}
		  	;

corpsFunction:KW_RETURN type FUNC_OUV KW_RETURN instructionReturnArbre FUNC_FERM 	{$$ = createCouple(NULL,$2);}
			|FUNC_OUV affectationArbre FUNC_FERM									{$$ = createCouple(NULL,NULL);}
			|FUNC_OUV methodAppelArbre FUNC_FERM									{$$ = createCouple(NULL,NULL);}
			;

instructionReturn	:	nUplet														{$$ = $1;}
					|	expression													{File f = createFile();addFile(f,$1);$$ = createNUplet(f,false);}
					| 	methodAppelReturn											{File f = createFile();addFile(f,$1);$$ = createNUplet(f,false);}
					;

instructionReturnArbre : nUpletArbre
						| expressionArbre
						|methodAppelArbre
						;

nUplet		:PAR_OUV valList PAR_FER												{$$ = createNUplet($2,true);}
			;

nUpletArbre : PAR_OUV valListArbre PAR_FER
			;

valList		:valeurs SEP_PARAM valList												{addFile($3,$1),$$=$3;}
			|valeurs																{File f= createFile();addFile(f,$1);$$=f;}
			;

valListArbre:valeursArbre SEP_PARAM valListArbre										
			|valeursArbre
			;

valeurs		:VAL_BOOL																{	Text t = createText("bool");
																						Type y = getTypeInTabType(type,t);
																						if(y == NULL){
																							fprintf(stderr,"probleme on a pas les bool\n");
																							return -1;
																						}
																						Var r = createVarWithType(y,createText(""));
																						bool* v = (bool*)malloc(sizeof(bool));
																						(*v) = $1;
																						setValue(r,v);
																						freeText(&t);
																						$$ = r;
																				    }
			|VAL_FLOAT																{	Text t = createText("float");
																						Type y = getTypeInTabType(type,t);
																						if(y == NULL){
																							fprintf(stderr,"probleme on a pas les float\n");
																							return -1;
																						}
																						Var r = createVarWithType(y,createText(""));
																						float* v = (float*)malloc(sizeof(float));
																						(*v) = $1;
																						setValue(r,v);
																						freeText(&t);
																						$$ = r;
																				    }
			|VAL_INT																{	Text t = createText("int");
																						Type y = getTypeInTabType(type,t);
																						if(y == NULL){
																							fprintf(stderr,"probleme on a pas les int\n");
																							return -1;
																						}
																						Var r = createVarWithType(y,createText(""));
																						int* v = (int*)malloc(sizeof(int));
																						(*v) = $1;
																						setValue(r,v);
																						freeText(&t);
																						$$ = r;
																				    }
			| IDENF																	{ Var v = getVarInPileVar(var,$1);
																					 Text t = $1;
																					  freeText(&t);
																					  if(v == NULL){
																					  	fprintf(stderr,"Erreur sémantique (valeurs : IDENF)\n");
																					 	return -1;
																					  }
 																					  $$ = v;
																					}
			| IDENF OP_FUNC IDENF													{ Var v = getVarInPileVar(var,$1);
																					  Text t = $1;
																					  freeText(&t);
																					  if(v == NULL){
																					  	fprintf(stderr,"Erreur sémantique (valeurs : IDENF->idenf)\n");
																					 	return -1;
																					  }
																					  Var w = getVarInVar(v,$3);
																					  if(w == NULL){
																					  	fprintf(stderr,"Erreur sémantique (valeurs : idenf->IDENF)\n");
																					 	return -1;
																					  }
																					  $$ = w;
																					}
			;

valeursArbre:VAL_BOOL														
			|VAL_FLOAT																
			|VAL_INT																
			| IDENF																	
			| IDENF OP_FUNC IDENF										
			;		

instruction :declaVar																
			|affectation															
			|methodAppel															
			;

affectation : IDENF OP_AFF instructionReturn										{	Var v = getVarInPileVar(var,$1);
																						 Text t = $1;
																						  freeText(&t);
																						  if(v == NULL){
																						  	fprintf(stderr,"Erreur sémantique (Affectation : IDENF)\n");
																						 	return -1;
																						  }
																						  N_Uplet c = $3;
																						  bool ok = affectationVarWithNUplet(v,c);
																						  freeNUplet(&c);

																						if(!ok){
																							fprintf(stderr,"Erreur sémantique (Affectation : type Non Egaux)\n");
																					 		return -1;
																						}

																					}
			| nUplet OP_AFF instructionReturn 										{	N_Uplet c = $1;
																						N_Uplet d = $3;
																						if(!affectationNUplet(c,d)){
																							freeNUplet(&c);
																							freeNUplet(&d);
																							fprintf(stderr,"Erreur sémantique (Affectation : nUplet different)\n");
																					 		return -1;
																						}
																						freeNUplet(&c);
																						freeNUplet(&d);
																					}
			| IDENF OP_FUNC IDENF OP_AFF instructionReturn							{Var v = getVarInPileVar(var,$1);
																					  Text t = $1;
																					  freeText(&t);
																					  if(v == NULL){
																					  	fprintf(stderr,"Erreur sémantique (AFFECTATION : IDENF->idenf)\n");
																					 	return -1;
																					  }
																					  Var w = getVarInVar(v,$3);
																					  if(w == NULL){
																					  	fprintf(stderr,"Erreur sémantique (AFFECTATION: idenf->IDENF)\n");
																					 	return -1;
																					  }
																					    N_Uplet c = $5;
																						  bool ok = affectationVarWithNUplet(v,c);
																						  freeNUplet(&c);

																						if(!ok){
																							fprintf(stderr,"Erreur sémantique (Affectation : type Non Egaux(i->i= t))\n");
																					 		return -1;
																						}
																					}
			;

affectationArbre : IDENF OP_AFF instructionReturnArbre										
			| nUpletArbre OP_AFF instructionReturnArbre 									
			| IDENF OP_FUNC IDENF OP_AFF instructionReturnArbre							
			;

methodAppel : IDENF OP_FUNC IDENF PAR_OUV valList PAR_FER							{Var v = getVarInPileVar(var,$1);
																					 Text cv = $1;
																					 Text cf = $3;
																					 File p = $5;
																					 freeText(&cv);
																					 if(v == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppel : variable inexistante\n");
																					 	Iterator i = getIteratorFile(p);
																						 while(hasNextIterator(i)){
																						 	Var l = (Var)nextDataIterator(i);
																						 	if(isMyNameVarWithChar(l,"")){
																						 		freeVar(&l);
																						 	}
																						 }
																						 freeIterator(&i);
																						 freeFile(&p);
																						 freeText(&cf);	
																					 	return -1;
																					 }

																					 //verif existance fonction
																					 if(!isMyFonctionVar(v,$3,p)){
																					 	fprintf(stderr,"Erreur sémantique (methodAppel : fonction inexistante\n");
																					 	Iterator i = getIteratorFile(p);
																						 while(hasNextIterator(i)){
																						 	Var l = (Var)nextDataIterator(i);
																						 	if(isMyNameVarWithChar(l,"")){
																						 		freeVar(&l);
																						 	}
																						 }
																						 freeIterator(&i);
																						 freeFile(&p);
																						 freeText(&cf);
																					 	return -1;
																					 }
																					 //exec fonction
																					 Var res = appFonctionVar(v,$3,p);
																					 Iterator i = getIteratorFile(p);
																					 while(hasNextIterator(i)){
																					 	Var l = (Var)nextDataIterator(i);
																					 	if(isMyNameVarWithChar(l,"")){
																					 		freeVar(&l);
																					 	}
																					 }
																					 freeIterator(&i);
																					 freeFile(&p);
																					 freeText(&cf);

																					 if(res != NULL){
																					 	//delete du res car pas de retour
																					 	free(res);
																					 }
																					}
			| IDENF OP_FUNC IDENF PAR_OUV PAR_FER									{Var v = getVarInPileVar(var,$1);
																					 Text cv = $1;
																					 Text cf = $3;
																					 freeText(&cv);
																					 if(v == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppel : variable inexistante\n");
																					 	freeText(&cf);	
																					 	return -1;
																					 }

																					 File p = createFile();
																					 //verif existance fonction
																					 if(!isMyFonctionVar(v,$3,p)){
																					 	fprintf(stderr,"Erreur sémantique (methodAppel : fonction inexistante\n");
																					 	freeFile(&p);
																					 	freeText(&cf);
																					 	return -1;
																					 }
																					 //exec fonction
																					 Var res = appFonctionVar(v,$3,p);
																					 freeFile(&p);
																					 freeText(&cf);

																					 if(res != NULL){
																					 	//delete du res car pas de retour
																					 	free(res);
																					 }

																					}
			;

methodAppelReturn : IDENF OP_FUNC IDENF PAR_OUV valList PAR_FER							{Var v = getVarInPileVar(var,$1);
																					 Text cv = $1;
																					 Text cf = $3;
																					 File p = $5;
																					 freeText(&cv);
																					 if(v == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : variable inexistante\n");
																					 	Iterator i = getIteratorFile(p);
																						 while(hasNextIterator(i)){
																						 	Var l = (Var)nextDataIterator(i);
																						 	if(isMyNameVarWithChar(l,"")){
																						 		freeVar(&l);
																						 	}
																						 }
																						 freeIterator(&i);
																						 freeFile(&p);
																						 freeText(&cf);	
																					 	return -1;
																					 }

																					 //verif existance fonction
																					 if(!isMyFonctionVar(v,$3,p)){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : fonction inexistante\n");
																					 	Iterator i = getIteratorFile(p);
																						 while(hasNextIterator(i)){
																						 	Var l = (Var)nextDataIterator(i);
																						 	if(isMyNameVarWithChar(l,"")){
																						 		freeVar(&l);
																						 	}
																						 }
																						 freeIterator(&i);
																						 freeFile(&p);
																						 freeText(&cf);
																					 	return -1;
																					 }
																					 //exec fonction
																					 Var res = appFonctionVar(v,$3,p);
																					 Iterator i = getIteratorFile(p);
																					 while(hasNextIterator(i)){
																					 	Var l = (Var)nextDataIterator(i);
																					 	if(isMyNameVarWithChar(l,"")){
																					 		freeVar(&l);
																					 	}
																					 }
																					 freeIterator(&i);
																					 freeFile(&p);
																					 freeText(&cf);

																					 if(res == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : pas de valeur de retour\n");
																					 	return -1;
																					 }
																					 $$ = res;
																					}
			| IDENF OP_FUNC IDENF PAR_OUV PAR_FER									{Var v = getVarInPileVar(var,$1);
																					 Text cv = $1;
																					 Text cf = $3;
																					 freeText(&cv);
																					 if(v == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : variable inexistante\n");
																					 	freeText(&cf);	
																					 	return -1;
																					 }

																					 File p = createFile();
																					 //verif existance fonction
																					 if(!isMyFonctionVar(v,$3,p)){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : fonction inexistante\n");
																					 	freeFile(&p);
																					 	freeText(&cf);
																					 	return -1;
																					 }
																					 //exec fonction
																					 Var res = appFonctionVar(v,$3,p);
																					 freeFile(&p);
																					 freeText(&cf);

																					 //renvoi la var
																					 if(res == NULL){
																					 	fprintf(stderr,"Erreur sémantique (methodAppelReturn : pas de valeur de retour\n");
																					 	return -1;
																					 }
																					 	$$ = res;
																					}
			;


methodAppelArbre : IDENF OP_FUNC IDENF PAR_OUV valListArbre PAR_FER							{printf("OK method_param\n");}
			| IDENF OP_FUNC IDENF PAR_OUV PAR_FER									{printf("OK method_funcVide\n");}
			;

expNum 		: expNum OP_PLUS expNum													{Var r = operationVar($1,$3,OPERATION_PLUS);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (PLUS)\n");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_MOINS expNum												{Var r = operationVar($1,$3,OPERATION_MOINS);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (MOINS)\n");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_MULTI expNum												{Var r = operationVar($1,$3,OPERATION_MULTI);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (MULTI)\n");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_DIV expNum													{Var r = operationVar($1,$3,OPERATION_DIV);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (DIV)\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| valeurs																{$$ = $1;}
			;

expNumArbre : expNumArbre OP_PLUS expNumArbre													
			| expNumArbre OP_MOINS expNumArbre												
																					
			| expNumArbre OP_MULTI expNumArbre											
			| expNumArbre OP_DIV expNumArbre												
			| valeursArbre																
			;

expression	: expression OP_AND expression											{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_AND,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expression OP_OR expression											{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_OR,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expComp																{$$ = $1;}
			;

expressionArbre	: expressionArbre OP_AND expressionArbre											
			| expressionArbre OP_OR expressionArbre											
			| expCompArbre																
			;

expComp     : expNum OP_EQ expNum													{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_EG,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum OP_DIFF expNum													{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_DIFF,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum OP_INF expNum													{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_INF,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum OP_INF_EQ expNum												{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_INFEG,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum OP_SUP expNum													{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_SUP,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum OP_SUP_EQ expNum												{Type a = getTypeInTabTypeWithChar(type,"bool");
																					 if(a == NULL){
																					 	fprintf(stderr,"Erreur sémantique (type : bool non trouvé)\n");
																					 	return -1;
																					 }
																					Var r = BoolOperationVar($1,$3,OPERATION_SUPEG,a);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (expression): and\n");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| expNum																{$$ = $1;}
			;

expCompArbre    : expNumArbre OP_EQ expNumArbre													
			| expNumArbre OP_DIFF expNumArbre													
			| expNumArbre OP_INF expNumArbre													
			| expNumArbre OP_INF_EQ expNumArbre												
			| expNumArbre OP_SUP expNumArbre													
			| expNumArbre OP_SUP_EQ expNumArbre												
			| expNumArbre															
			;


%%

int yyerror(char* s){
		printf("ERROR %s \n", s);
		return 0;
	}

int main(){
	type =  createTabType();
	var  = createPileVar();
	int parseError = yyparse();
	freeTabType(&type);
	freePileVar(&var);
	printf("CODE PARSE %d \n",parseError);

	return 0;
}