%{
	#include <string.h>
	#include "Text.h"
	#include "TabType.h"
	#include "PileVar.h"
	#include "File.h"
	#include "Couple.h"
	#include "TLC_GPE_7_Grammaire_v1.tab.h"
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
OP_INF			"<"
OP_INF_EQ		"<="
OP_SUP			">"
OP_SUP_EQ		">="
OP_DIFF			"!="
OP_EQ 			"=="
OP_AND			"&&"
OP_OR			"||"
KW_ENDCLASS		endClass
VAL_BOOL		"true"|"false"
VAL_INT			[0-9]+
VAL_FLOAT		[0-9]+"."[0-9]*
SEP_PARAM		","

COMMENT			"//".*\n


%s SIGNED_NUM_POSSIBLE
%s SIGNED_NUM_INTERDIT

%%

{KW_CLASS} 									{BEGIN (SIGNED_NUM_POSSIBLE);return KW_CLASS;}
{KW_EXTEND}									{BEGIN (SIGNED_NUM_POSSIBLE);return KW_EXTEND;}
{KW_DATA}									{BEGIN (SIGNED_NUM_POSSIBLE);return KW_DATA;}
{KW_FUNCTION}								{BEGIN (SIGNED_NUM_POSSIBLE);return KW_FUNCTION;}
{KW_RETURN}									{BEGIN (SIGNED_NUM_POSSIBLE);return KW_RETURN;}
{KW_ENDCLASS}								{BEGIN (SIGNED_NUM_POSSIBLE);return KW_ENDCLASS;}

{SEP_INSTRUCT}								{BEGIN (SIGNED_NUM_POSSIBLE);return SEP_INSTRUCT;}
{PAR_OUV}									{BEGIN (SIGNED_NUM_POSSIBLE);return PAR_OUV;}
{PAR_FER}									{BEGIN (SIGNED_NUM_POSSIBLE);return PAR_FER;}
{FUNC_OUV}									{BEGIN (SIGNED_NUM_POSSIBLE);return FUNC_OUV;}
{FUNC_FERM}									{BEGIN (SIGNED_NUM_POSSIBLE);return FUNC_FERM;}
{SEP_PARAM}									{BEGIN (SIGNED_NUM_POSSIBLE);return SEP_PARAM;}

{OP_PLUS}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_PLUS;}
{OP_MOINS}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_MOINS;}
{OP_MULTI}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_MULTI;}
{OP_DIV}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_DIV;}
{OP_AFF}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_AFF;}
{OP_FUNC}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_FUNC;}
{OP_INF}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_INF;}
{OP_INF_EQ}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_INF_EQ;}
{OP_SUP}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_SUP;}
{OP_SUP_EQ}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_SUP_EQ;}
{OP_DIFF}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_DIFF;}
{OP_EQ}										{BEGIN (SIGNED_NUM_POSSIBLE);return OP_EQ;}
{OP_AND}									{BEGIN (SIGNED_NUM_POSSIBLE);return OP_AND;}
{OP_OR}										{BEGIN (SIGNED_NUM_POSSIBLE);return OP_OR;}

<SIGNED_NUM_POSSIBLE>{SIGNE}{VAL_INT}		{BEGIN (SIGNED_NUM_INTERDIT);yylval.valInt = atoi(yytext);return VAL_INT;}
<SIGNED_NUM_POSSIBLE>{SIGNE}{VAL_FLOAT}		{BEGIN (SIGNED_NUM_INTERDIT);yylval.valFloat = atof(yytext);return VAL_FLOAT;}

{VAL_BOOL}									{BEGIN (SIGNED_NUM_INTERDIT);yylval.valBool = strcmp(yytext,"true") == 0;return VAL_BOOL;}
{VAL_INT}									{BEGIN (SIGNED_NUM_INTERDIT);yylval.valInt = atoi(yytext);return VAL_INT;}				//faire les int flaot signé
{VAL_FLOAT}									{BEGIN (SIGNED_NUM_INTERDIT);yylval.valFloat = atof(yytext);return VAL_FLOAT;}
{TYP_PRIMITIF} 								{BEGIN (SIGNED_NUM_POSSIBLE);yylval.nom = createText(yytext);return TYP_PRIMITIF;}


{IDENF}		 								{BEGIN (SIGNED_NUM_INTERDIT);yylval.nom = createText(yytext);return IDENF;}
{COMMENT}									

[ \t\n\r]+		
.											{return -1;}

%%



