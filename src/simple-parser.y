/* Onoma arxeiou:	simple-parser.y
   Perigrafh:		Aplos syntaktikos analyths (kwdikas gia to ergaleio Bison)
   Syggrafeas:		Ergasthrio Metaglwttistwn, Tmhma Mhx.Plhroforikhs TE, TEI Athhnas
   Sxolia:		O syntaktikos analyths anagnwrizei monaxa:
				1) Dhlwsh metablhths typou integer =========> int a;
				2) Anathesh timhs akeraiou se metablhth ====> a = 5;
				3) Anathesh timhs metablthhs se metablhth ==> a = b;
			Katanoei kai xrhsimopoiei stous grammatikous kanones tis akolouthes
			lektikes monades pou parexontai/anagnwrizontai apo to ergaleio Flex:
				1) SINT		H leksh "int" gia orismo metablhths integer
				2) SEMI		O xarakthras ';' ws termatikos entolhs
				3) ASSIGNOP	O xarakthras '=' gia tis anatheseis timwn
				4) IDENTIFIER	Anagnwristiko / onoma metablhths
				5) INTCONST	Akeraios arithmos
*/

%{

/* --------------------------------------------------------------------------------
   Orismoi kai dhlwseis glwssas C. Otidhpote exei na kanei me orismo h arxikopoihsh
   metablhtwn, arxeia header kai dhlwseis #define mpainei se auto to shmeio */

#include <stdio.h>
#include <string.h>
int line=1;
int errflag=0;
int incorrectphrases=0;
int correctphrases=0;
extern char *yytext;
#define YYSTYPE char *
int yyerror(char *s);
FILE *yyin;
FILE *yyout;

//pinakas me ola ta simvola
char *sym[] = {"=","+","-","*","/","<=",">=","++","!=","==","<",">","%","+=","-=","*=","/=","!","&&","||","--","&"}; 
	

%}

/* -----------------------------
   Dhlwseis kai orismoi Bison */

/* Orismos twn anagnwrisimwn lektikwn monadwn. */			
%token SINT FLOAT STRING SEMI ASSIGNOP PLUS SUB MULT DIV MOD LESS_THAN LESS_THAN_OR_EQUAL_TO BIGGER_THAN BIGGER_THAN_OR_EQUAL_TO INCREMENT DECREMENT NOT_EQUAL_TO EQUAL_TO ADDITION_AND_ASSIGNMENT_OPERATOR SUBSTRACT_AND_ASSIGNMENT_OPERATOR MULTIPLY_AND_ASSIGNMENT_OPERATOR DIVISION_AND_ASSIGNMENT_OPERATOR LOGICAL_AND_OPERATOR LOGICAL_OR_OPERATOR BITWISE_AND LOGICAL_NOT DELIMITERS KEYWORDS IDENTIFIER INTCONST STRINGS WHITESPACE ONE_LINE_COMMENTS NEWLINE

/* Orismos proteraiothtwn sta tokens ksekinontas me tis paraintheseis, meta me ton pollaplasiamo kai tin diairesi, kai aristeri proseteristikotita*/
%left PLUS SUB
%left MULT DIV
%left '('  ')'

/* Orismos tou symbolou enarkshs ths grammatikhs */

%start program

%%

/* --------------------------------------------------------------------------------
   Orismos twn grammatikwn kanonwn. Kathe fora pou antistoixizetai enas grammatikos
   kanonas me ta dedomena eisodou, ekteleitai o kwdikas C pou brisketai anamesa sta
   agkistra. H anamenomenh syntaksh einai:
				onoma : kanonas { kwdikas C } */
//orismos twn triwn xarakthristikwn dhlwsh,anathesi kai ektelesi praxhs					    
program : program decl 
	| program assign 
	| program error NEWLINE { fprintf(yyout,"\n\t### Line:%d ERROR\n", line-1); errflag=1;}
	|  
	;
	
    
type	: SINT 	   { $$ = strdup(yytext); }   
	| FLOAT 	   { $$ = strdup(yytext); }
	| STRING	   { $$ = strdup(yytext); }
	;
	

aid	: IDENTIFIER	{ $$ = strdup(yytext); }     
	;
	
tim	: INTCONST		{ $$ ="SINT"; }
	| FLOAT	 { $$ = "FLOAT";}
	| IDENTIFIER	{ $$ = "IDENTIFIER"; }
	;

//orismos gia tis dhlwseis metavlhtwn	
decl	: type aid SEMI { fprintf(yyout,"\n\t### Line:%d Declaration\n", line);correctphrases++; }
	;	

//orismos gia thn anathesi timwn(integer h float) h allwn metavlhtwn se  metavlhtes
assign	: aid ASSIGNOP tim SEMI
		{
			if (strcmp($3,"SINT"))
			{fprintf(yyout,"\n\t### Line:%d Variable assignment\n", line);correctphrases++;}
			
			else if (strcmp($3,"FLOAT"))
			{fprintf(yyout,"\n\t### Line:%d Variable assignment\n", line);correctphrases++;}
			
			else if (strcmp($3,"STRING"))
			{fprintf(yyout,"\n\t### Line:%d Variable assignment\n", line);correctphrases++;}
			
			else
			{fprintf(yyout,"\n\t### Line:%d Value assignment\n", line);correctphrases++;}
			
		}
	;
%%
//tmhma kwdika gia tis praxeis(arithmitikes,sigkritikes,logikes) gia tis metavlites	
/*	
expr:  SINT {$$=atoi(yytext);}
         expr "+" expr   { printf("\t[BISON] Result for addition: %d\n",$1+$2); $$=$1+$2;correctphrases++;}
        | expr "*" expr   { printf("\t[BISON] Result for multiplication: %d\n", $1*$2);$$=$1*$2;}
        | expr "-" expr   { printf("\t[BISON] Result : %d\n", $1-$2);$$=$1-$2;}
        | expr "/" expr   { printf("\t[BISON] Result : %d\n", $1/$2);$$=$1/$2;}
        | expr "%" expr   { printf("\t[BISON] Result : %d\n", $1%$2);$$=$1%$2;}
        | expr "<=" expr   { printf("\t[BISON] Result : %d\n", $1<=$2);$$=$1<=$2;}
        | expr "<" expr   { printf("\t[BISON] Result : %d\n", $1<$2);$$=$1<$2;}
        | expr ">=" expr   { printf("\t[BISON] Result : %d\n", $1>=$2);$$=$1>=$2;}
        | expr ">" expr   { printf("\t[BISON] Result : %d\n", $1>$2);$$=$1>$2;}
        | expr "++" expr   { printf("\t[BISON] Result : %d\n", $1++);$$=$1++;}
        | expr "--" expr   { printf("\t[BISON] Result : %d\n", $1--);$$=$1--;}
        | expr "!=" expr   { printf("\t[BISON] Result : %d\n", $1!=$2);$$=$1!=$2;}
        | expr "==" expr   { printf("\t[BISON] Result : %d\n", $1==$2);$$=$1==$2;}
        | expr "+=" expr   { printf("\t[BISON] Result : %d\n", $1+=$2);$$=$1+=$2;}
        | expr "-=" expr   { printf("\t[BISON] Result : %d\n", $1-=$2);$$=$1-=$2;}
        | expr "*=" expr   { printf("\t[BISON] Result : %d\n", $1*=$2);$$=$1*=$2;}
        | expr "/=" expr   { printf("\t[BISON] Result : %d\n", $1/=$2);$$=$1/=$2;}
        | expr "&&" expr   { printf("\t[BISON] Result : %d\n", $1&&$2);$$=$1&&$2;}
        | expr "&" expr   { printf("\t[BISON] Result : %d\n", $1&$2);$$=$1&$2;}
        | expr "||" expr   { printf("\t[BISON] Result : %d\n", $1||$2);$$=$1||$2;}
        | expr "!" expr   { printf("\t[BISON] Result : %d\n", $1!$2);$$=$1!$2;}
        ;
			
*/



/* --------------------------------------------------------------------------------
   Epiprosthetos kwdikas-xrhsth se glwssa C. Sto shmeio auto mporoun na prostethoun
   synarthseis C pou tha symperilhfthoun ston kwdika tou syntaktikoy analyth */


/* H synarthsh yyerror xrhsimopoieitai gia thn anafora sfalmatwn. Sygkekrimena kaleitai
   apo thn yyparse otan yparksei kapoio syntaktiko lathos. Sthn parakatw periptwsh h
   synarthsh epi ths ousias den xrhsimopoieitai kai aplws epistrefei amesws. */

int yyerror(char *s)
{}


/* O deikths yyin einai autos pou "deixnei" sto arxeio eisodou. Ean den ginei xrhsh
   tou yyin, tote h eisodos ginetai apokleistika apo to standard input (plhktrologio) */




/* H synarthsh main pou apotelei kai to shmeio ekkinhshs tou programmatos.
   Ginetai elegxos twn orismatwn ths grammhs entolwn kai klhsh ths yyparse
   pou pragmatopoiei thn syntaktikh analysh. Sto telos ginetai elegxos gia
   thn epityxh h mh ekbash ths analyshs. */
//an kleithei me 3 orismata,to deutero orisma tha einai to arxeio pou tha diavasei kai to trito tha einai to arxeio pou tha grapsei
int main(int argc,char **argv)
{
	int i;
	if(argc == 3)
	{
		yyin=fopen(argv[1],"r");
		yyout=fopen(argv[2],"w");
	}
	else
	{
		yyin=stdin;
		yyout=stdout;
	}
	int parse = yyparse();
	//typwnei mazi tis swstes kai lathos lexeis kathws kai tis swstes kai lathos ekfraseis me tis sinartiseis pou ftiaxame
	printcorrect();
	printincorrect();
	fprintf(yyout,"\n\tIncorrect phrases:%d",incorrectphrases);
	fprintf(yyout,"\n\tCorrect phrases:%d",correctphrases);

	if (errflag==0 && parse==0)
	{
		fprintf(yyout,"\nINPUT FILE: PARSING SUCCEEDED.\n", parse);}
	else
		{fprintf(yyout,"\nINPUT FILE: PARSING FAILED.\n", parse);}
	
	return 0;
}
