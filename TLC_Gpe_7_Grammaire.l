%{
	#include <string.h>
%}
CHIFFRE			[0-9]
MINUS			[a-z]
MAJUS			[A-Z]
SIGNE			[+-]

KW_CLASS 		class
IDENF		 	[a-zA-Z]([a-zA-Z]|[0-9]|"_")*
KW_EXTEND		extend
KW_DATA			data
TYP_PRIMITIF 	int|bool|float
SEP_INSTRUCT	";"
KW_FUNCTION		function
PAR_OUV			"("
PAR_FER			")"
KW_RETURN		return
FUNC_OUV		"{"
FUNC_FERM		"}"
OP_PLUS			[+]
OP_MOINS		"-"
OP_MULTI		"*"
OP_DIV			"/"
OP_AFF			":="
OP_FUNC			"->"
KW_ENDCLASS		endClass
VAL_BOOL		"true"|"false"
VAL_INT			[0-9]+
VAL_FLOAT		[0-9]+"."[0-9]*
SEP_PARAM		","

COMMENT			"//".*\n


%s SIGNED_NUM_POSSIBLE
%s SIGNED_NUM_INTERDIT

%%

{KW_CLASS} 									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_CLASS trouve : %s\n\n" , yytext);}
{KW_EXTEND}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_EXTEND trouve : %s\n\n" , yytext);}
{KW_DATA}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_DATA trouve : %s\n\n" , yytext);}
{KW_FUNCTION}								{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_FUNCTION trouve : %s\n\n" , yytext);}
{KW_RETURN}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_RETURN trouve : %s\n\n" , yytext);}
{KW_ENDCLASS}								{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n KW_ENDCLASS trouve : %s\n\n" , yytext);}

{SEP_INSTRUCT}								{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n SEP_INSTRUCT trouve : %s\n\n" , yytext);}
{PAR_OUV}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n PAR_OUV trouve : %s\n\n" , yytext);}
{PAR_FER}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n PAR_FER trouve : %s\n\n" , yytext);}
{FUNC_OUV}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n FUNC_OUV trouve : %s\n\n" , yytext);}
{FUNC_FERM}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n FUNC_FERM trouve : %s\n\n" , yytext);}
{SEP_PARAM}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n SEP_PARAM trouve : %s\n\n" , yytext);}

{OP_PLUS}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_PLUS trouve : %s\n\n" , yytext);}
{OP_MOINS}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_MOINS trouve : %s\n\n" , yytext);}
{OP_MULTI}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_MULTI trouve : %s\n\n" , yytext);}
{OP_DIV}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_DIV trouve : %s\n\n" , yytext);}
{OP_AFF}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_AFF trouve : %s\n\n" , yytext);}
{OP_FUNC}									{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n OP_FUNC trouve : %s\n\n" , yytext);}


<SIGNED_NUM_POSSIBLE>{SIGNE}{VAL_INT}		{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n SIGNED_VAL_INT trouve : %s\n\n" , yytext);}
<SIGNED_NUM_POSSIBLE>{SIGNE}{VAL_FLOAT}		{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n VAL_FLOAT trouve : %s\n\n" , yytext);}

{VAL_BOOL}									{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n VAL_BOOL trouve : %s\n\n" , yytext);}
{VAL_INT}									{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n VAL_INT trouve : %s\n\n" , yytext);}				//faire les int flaot signé
{VAL_FLOAT}									{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n VAL_FLOAT trouve : %s\n\n" , yytext);}
{TYP_PRIMITIF} 								{BEGIN (SIGNED_NUM_POSSIBLE);printf("\n\n TYP_PRIMITIF trouve : %s\n\n" , yytext);}


{IDENF}		 								{BEGIN (SIGNED_NUM_INTERDIT);printf("\n\n IDENF trouve : %s\n\n" , yytext);}
{COMMENT}									{printf("\n\n COM trouve : %s\n\n" , yytext);}

[ \t\n]+		
.											{printf("\n\n Erreur trouve : %d\n\n" , yytext[0]);return -1;}

%%



int main(){
	BEGIN (SIGNED_NUM_POSSIBLE);
	int code = yylex();
	printf("\n\n Fin du programme avec le code %d \n\n",code);
	
	return 0;
}