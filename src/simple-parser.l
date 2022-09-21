/* Onoma arxeiou:	simple-parser.l
   Perigrafh:		Aplos lektikos analyths - meros tou antistoixou syntaktikou analyth
			(kwdikas gia to ergaleio Flex)
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma Mhx.Plhroforikhs TE, TEI Athhnas
   Sxolia:		To paron programma ylopoiei (me th xrhsh Flex) enan aplo lektiko
			analyth pou anagnwrizei:
				1) Tabs kai kena
				2) Anagnwristika (identifiers - onomata metablhtwn)
				3) Akeraious arithmous
				4) Th leksh "int"
				5) Ton xarakthra ';'
				6) Ton xarakthra '='
				7) Ton eidiko xarakthra '\n' - newline
			Se opoiadhpote allh periptwsh ektypwnei to mhnyma "Token error"
*/

%option noyywrap
%x C_COMMENT      
/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens */
#include "simple-parser.tab.h"
int C_COMMENT;   /*δήλωση C_COMMENT variable για τη διαχείριση των σχολίων */
int correctwords=0;
int incorrectwords=0;
extern int flag;
extern int line;
extern void printcorrect();
extern void printincorrect();
FILE *yyin;
FILE *yyout;

void prn(char *s);


%}

/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makrsokelwn kai dysnohtwn, kanonikwn ekfrasewn */

DELIMITERS [ \t]+
IDENTIFIER [A-Za-z][A-Za-z0-9]*(_[A-Za-z0-9]+)*
FLOAT		[0-9]+[.][0-9]+[e|E][0-9]+|[0-9]+[.][0-9]+|[0-9]+[e|E][0-9]+
STRINGS	["][\w\s]*.*[^\n\"]["]
ONE_LINE_COMMENTS	[/][/]+.*
WHITESPACE	[\s]
OPERATOR	"+"|"-"|"*"|"/"|"<="|">="|"++"|"!="|"=="|"<"|">"|"%"|"+="|"-="|"*="|"/="|"!"|"&&"|"||"|"--"|"&"
KEYWORDS	("int")|("float")|("string")|("if")|("else")|("while")|("do")|("break")|("continue")|("double")|("return")|("case")|("sizeof")|("long")|("short")|("switch")|("void")|("struct")|("func")|("const")|("for")
INTCONST		 0|[1-9]+[0-9]*|0[x|X][0-9A-F]+|0[0-7]+


/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias sygkekrimenhs arithmhtiks timhs pou antiproswpeuei thn lektikh
   monada pou diabasthke. H timh auth xrhsimopoieitai apo to ergaleio
   Bison gia thn syntaktikh analysh ths eisodou */

%%
         // αναγνωρίζει το token και to επιστρέφει,αν πρόκειται για ολοκληρωμένη λέξη(ή μη ολοκληρωμένη) αυξάνει τον αντίστοιχο μετρητή κατά ένα
         
"int"				{prn("INT"); correctwords++;return SINT;}
"float"			{prn("FLOAT"); correctwords++;return FLOAT;}
"string" 			{prn("STRING"); correctwords++;return STRING;}
";"				{prn("SEMI"); return SEMI;}
"="				{prn("ASSIGNOP"); return ASSIGNOP;}
"+"				{prn("PLUS"); return PLUS;}
"-"				{prn("SUB"); return SUB;}
"*"				{prn("MULT"); return MULT;}
"/"				{prn("DIV"); return DIV;}
"%"				{prn("MOD"); return MOD;}
"<"				{prn("LESS THAN"); return LESS_THAN;}
"<="			{prn("LESS THAN OR EQUAL TO"); return LESS_THAN_OR_EQUAL_TO;}
">"				{prn("BIGGER THAN");	return BIGGER_THAN;}
">="			{prn("BIGGER THAN OR EQUAL TO"); return BIGGER_THAN_OR_EQUAL_TO;}
"++"			{prn("INCREMENT"); return INCREMENT;}
"--"			{prn("DECREMENT");	return DECREMENT;}
"!="			{prn("NOT EQUAL TO");	return NOT_EQUAL_TO;}
"=="			{prn("EQUAL TO");	return EQUAL_TO;}
"+="			{prn("ADDITION AND ASSIGNMENT OPERATOR"); return ADDITION_AND_ASSIGNMENT_OPERATOR;}
"-="			{prn("SUBSTRACT AND ASSIGNMENT OPERATOR"); return SUBSTRACT_AND_ASSIGNMENT_OPERATOR;}
"*="			{prn("MULTIPLY AND ASSIGNMENT OPERATOR"); return MULTIPLY_AND_ASSIGNMENT_OPERATOR;}
"/="			{prn("DIVISION AND ASSIGNMENT OPERATOR"); return DIVISION_AND_ASSIGNMENT_OPERATOR;}
"&&"			{prn("LOGICAL AND OPERATOR"); return LOGICAL_AND_OPERATOR;}
"||"			{prn("LOGICAL OR OPERATOR"); return LOGICAL_OR_OPERATOR;}
"&"				{prn("BITWISE AND");	return BITWISE_AND;}
"!"				{prn("LOGICAL NOT");	return LOGICAL_NOT;}   
{DELIMITERS}			{}
{KEYWORDS}		{prn("KEYWORDS"); correctwords++;return KEYWORDS;}
{IDENTIFIER} 	{prn("IDENTIFIER"); correctwords++;return IDENTIFIER;}
{INTCONST}		{prn("INTCONST");correctwords++;	return INTCONST;}
{FLOAT}		{prn("FLOAT");correctwords++;	return FLOAT;}
{STRINGS}		{prn("STRINGS"); correctwords++;return STRINGS;}
{WHITESPACE}	{prn("WHITESPACE");incorrectwords++;	return WHITESPACE;}  /*αν δεχτεί whitespace χαρακτήρα τον αγνοεί και συνεχίζει κανονικά*/
{ONE_LINE_COMMENTS}	{} /*αν γραφτεί σχόλιο μίας γραμμής το αγνοεί και συνεχίζει κανονικά*/
\n 				{prn("\n");line++;  }  /*όταν δεχτεί το χαρακτήρα new line αλλάζει γραμμή και αυξάνει το μετρητή των γραμμών κατά 1*/
<<EOF>>			{prn("end of file\n"); exit(0);}   /*όταν φτάσει στο τέλος του αρχείου τυπώνει το αντίστοιχο μήνυμα και σταματάει την εκτέλεση*/ 
"/*"            {BEGIN(C_COMMENT);}   /*αν συναντήσει το /* ξεκινάει η εκτέλεση του κώδικα των σχολιών που ακολουθεί παρακάτω*/
<C_COMMENT>"*/" {BEGIN(0);}   /*αν συναντήσει αυτό το χαρακτήρα βγαίνει από την επανάληψη εκτέλεσης των σχολιών και ολοκληρώνεται*/
<C_COMMENT>\n   {}    /*αν δεχτεί το \n το αγνοεί και συνεχίζει να εκτελεί τον κώδικα των σχολίων*/
<C_COMMENT>.    {}    /*αν δεχτεί οποιονδήποτε άλλο χαρακτήρα τον αγνοεί και συνεχίζει να εκτελεί τον κώδικα των σχολίων*/
. 		{prn("Token error\n");incorrectwords++;}

%%
// Pinakas me ola ta tokens


/* H synarthsh prn typwnei sthn othonh ton typo tou anagnwristikou (px. ASSIGNOP)
   pou egine match kathws kai to idio to keimeno (px. =) tou anagnwristikou. O
   logos yparkshs ths einai kathara gia kalyterh katanohsh tou kwdika kai gia
   genikoterh dieykolynsh sto debugging ths efarmoghs */

void prn(char *s)
{
	fprintf(yyout,"\n\t%s: %s ", s, yytext);
	
}
//typwnei me tis dio sinartiseis tis swstes kai lathos lexeis
void printcorrect(){
	fprintf(yyout,"\n\tCorrect Words:%d ",correctwords);
	
}
void printincorrect(){
	fprintf(yyout,"\n\tIncorrect Words:%d",incorrectwords);
	
}
	

