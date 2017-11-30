%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
%}
%token KW_CLASS 
%token IDENF
%token KW_EXTEND
%token KW_DATA
%token TYP_PRIMITIF
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
%token VAL_BOOL
%token VAL_INT
%token VAL_FLOAT
%token SEP_PARAM

%start prog
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

instructionReturn	:	nUplet
					|	expression
					| 	methodAppel
					;

nUplet		:PAR_OUV valList PAR_FER
			|valeurs
			;

valList		:valeurs SEP_PARAM valList
			|valeurs

valeurs		:VAL_BOOL
			|VAL_FLOAT
			|VAL_INT
			| IDENF
			;

instruction :declaVar
			|affectation
			|methodAppel
			;

expression : expNum
			| expBool
			;

affectation : IDENF OP_AFF instructionReturn
			;

methodAppel : IDENF OP_FUNC IDENF PAR_OUV valList PAR_FER
			| IDENF OP_FUNC IDENF PAR_OUV PAR_FER
			;

expNum 		: VAL_INT
			;

expBool		: VAL_BOOL
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