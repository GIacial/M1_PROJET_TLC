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
%type<variable> instructionReturn
%type<typeVar>  type
%type<file> 	valList

%union{
	Text 	nom;
	int 	valInt;
	float 	valFloat;
	bool 	valBool;
	Var 	variable;
	Type    typeVar;
	File 	file;
}
%%

prog			:bloc  prog															{printf("Ok Prog\n");}
				|bloc 																{printf("Ok Prog_FIN\n");YYACCEPT;}
				;

bloc		: class 																{printf("Ok BLOC_CLASS\n");}
			|instruction SEP_INSTRUCT												{printf("Ok BLOC_INSTRUCTION\n");}
			;

class 		:enteteClass contenuClass KW_ENDCLASS									{printf("Ok CLASS\n");}
			;

enteteClass	:KW_CLASS IDENF															{printf("Ok ENTETE_CLASS\n");}
			|KW_CLASS IDENF KW_EXTEND IDENF											{printf("Ok ENTETE_CLASS_EXTEND\n");}
			;

contenuClass:KW_DATA data KW_FUNCTION declaFunction 								{printf("Ok CONTENU_CLASS_DF\n");}
			|KW_DATA  KW_FUNCTION declaFunction 									{printf("Ok CONTENU_CLASS_F\n");}
			|KW_DATA data KW_FUNCTION  												{printf("Ok CONTENU_CLASS_D\n");}
			;

data      	:declaVar SEP_INSTRUCT data 											{printf("Ok DATA\n");}
			|declaVar SEP_INSTRUCT  												{printf("Ok DATA_Fin\n");}
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

declaFunction:IDENF parametreDecla corpsFunction SEP_INSTRUCT declaFunction 		{printf("Ok Function\n");}
			|IDENF parametreDecla corpsFunction SEP_INSTRUCT						{printf("Ok Function_FIN\n");}	
			;


parametreDecla	:PAR_OUV parametre PAR_FER											{printf("Ok Function Param\n");}
				|PAR_OUV PAR_FER													{printf("Ok Function No Param \n");}
			;

parametre 	:declaVar SEP_PARAM parametre 											{printf("Ok Function_Params\n");}
			|declaVar																{printf("Ok Function_Param_FIN\n");}
		  	;

corpsFunction:KW_RETURN type FUNC_OUV KW_RETURN instructionReturn FUNC_FERM 		{printf("Ok Function_Corps_Return\n");}
			|FUNC_OUV affectation FUNC_FERM											{printf("Ok Function_Corps\n");}
			|FUNC_OUV methodAppel FUNC_FERM											{printf("Ok Function_Corps\n");}
			;

instructionReturn	:	nUplet														{printf("Ok Instruc_return_1\n");}
					|	expression													{$$ = $1;}
					| 	methodAppel													{printf("Ok Instruc_return_3 (Verif type retour fonction)\n");}
					;

nUplet		:PAR_OUV valList PAR_FER												{printf("N-uplet non gere\n");File a = $1;freeFile(&a);}

			;

valList		:valeurs SEP_PARAM valList												{addFile($3,$1),$$=$3;}
			|valeurs																{File f= createFile();addFile(f,$1);$$=f;}

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

instruction :declaVar																{printf("Ok Instruction_1\n");}
			|affectation															{printf("OK Instruction_2\n");}
			|methodAppel															{printf("OK Instruction_3\n");}
			;

affectation : IDENF OP_AFF instructionReturn										{	Var v = getVarInPileVar(var,$1);
																						 Text t = $1;
																						  freeText(&t);
																						  if(v == NULL){
																						  	fprintf(stderr,"Erreur sémantique (Affectation : IDENF)\n");
																						 	return -1;
																						  }
																						  Var c = $3;
																						  
																						  bool ok = copieVarInVar(v,c);

																						if(isMyNameVarWithChar(c,"")){//var tmp
																							freeVar(&c);
																						}

																						if(!ok){
																							fprintf(stderr,"Erreur sémantique (Affectation : type Non Egaux)\n");
																					 		return -1;
																						}

																					}
			| nUplet OP_AFF instructionReturn 										{printf("OK affectation nUplet");}
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
																					    Var c = $5;
																						  
																						  bool ok = copieVarInVar(w,c);

																						if(isMyNameVarWithChar(c,"")){//var tmp
																							freeVar(&c);
																						}

																						if(!ok){
																							fprintf(stderr,"Erreur sémantique (Affectation : type Non Egaux(i->i= t))\n");
																					 		return -1;
																						}
																					}
			;

methodAppel : IDENF OP_FUNC IDENF PAR_OUV valList PAR_FER							{printf("OK method_param\n");}
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


%%

int yyerror(char* s){
		printf("ERROR %s \n", s);
		return 0;
	}

int main(){
	type =  createTabType();
	var  = createPileVar();
	int parseError = yyparse();
	printf("CODE PARSE %d \n",parseError);
	return 0;
}