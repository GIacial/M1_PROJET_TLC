%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
	extern int yylex();
	extern int yyerror(char*);

	#include "TabType.h"
	#include "PileVar.h"
	#include "File.h"
	#include "Outils.h"
	#include "Var.h"
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

%union{
	Text 	nom;
	int 	valInt;
	float 	valFloat;
	bool 	valBool;
	Var 	variable;
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

declaVar	:type IDENF																{printf("Ok Variable\n");}
			;

type 		:TYP_PRIMITIF															{printf("Ok TYPE_Primitif\n");}
			|IDENF																	{printf("Ok TYPE_Class\n");}
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
					|	expression													{printf("Ok Instruc_return_2\n");}
					| 	methodAppel													{printf("Ok Instruc_return_3\n");}
					;

nUplet		:PAR_OUV valList PAR_FER												{printf("Ok nUplet_1\n");}

			;

valList		:valeurs SEP_PARAM valList												{printf("Ok valList\n");}
			|valeurs																{printf("Ok valList_fin\n");}

valeurs		:VAL_BOOL																{printf("Ok VAL_BOOL\n");}
			|VAL_FLOAT																{printf("Ok VAL_FLOAT\n");}
			|VAL_INT																{printf("Ok VAL_INT\n");}
			| IDENF																	{printf("Ok VAriable\n");}
			;

instruction :declaVar																{printf("Ok Instruction_1\n");}
			|affectation															{printf("OK Instruction_2\n");}
			|methodAppel															{printf("OK Instruction_3\n");}
			;

affectation : IDENF OP_AFF instructionReturn										{printf("OK affectation\n");}
			| nUplet OP_AFF instructionReturn 										{printf("OK affectation nUplet");}
			;

methodAppel : IDENF OP_FUNC IDENF PAR_OUV valList PAR_FER							{printf("OK method_param\n");}
			| IDENF OP_FUNC IDENF PAR_OUV PAR_FER									{printf("OK method_funcVide\n");}
			| IDENF OP_FUNC IDENF													{printf("OK method_Var\n");}
			;

expNum 		: expNum OP_PLUS expNum													{Var r = operationVar($1,$3,OPERATION_PLUS);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (PLUS)");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_MOINS expNum												{Var r = operationVar($1,$3,OPERATION_MOINS);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (MOINS)");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_MULTI expNum												{Var r = operationVar($1,$3,OPERATION_MULTI);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (MULTI)");
																					 	return -1;
																					 }
																					 $$ = r;}
			| expNum OP_DIV expNum													{Var r = operationVar($1,$3,OPERATION_DIV);
																					 if(r == NULL){
																					 	fprintf(stderr,"Erreur sémantique (DIV)");
																					 	return -1;
																					 }
																					 $$ = r;
																					}
			| valeurs																{$$ = $1;}
			;

expression	: expression OP_AND expression											{printf("OK and");}
			| expression OP_OR expression											{printf("OK or");}
			| expComp																{printf("OK expComp");}
			;

expComp     : expNum OP_EQ expNum													{printf("OK ==");}
			| expNum OP_DIFF expNum													{printf("OK !=");}	
			| expNum OP_INF expNum													{printf("OK <");}
			| expNum OP_INF_EQ expNum												{printf("OK <=");}
			| expNum OP_SUP expNum													{printf("OK >");}
			| expNum OP_SUP_EQ expNum												{printf("OK >=");}
			| expNum																{printf("OK expNum");}
			;


%%

int yyerror(char* s){
		printf("ERROR %s \n", s);
		return 0;
	}

int main(){
	int parseError = yyparse();
	printf("CODE PARSE %d \n",parseError);
	return 0;
}