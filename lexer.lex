%{
#include "lexer.h"
#include <math.h>

void TokenOutput(int& row, int& col, const char* type, char* text);
void PassN(int& row, int& col, const char* type, char* text);
int row = 1;
int col = 1;
int TokensNumber = 0;
%}
%option     nounput
%option     noyywrap

WHITESPACE  [\ \t\r]+
KEYWORDS     ("AND"|"ARRAY"|"BEGIN"|"BY"|"DIV"|"DO"|"ELSE"|"ELSIF"|"END"|"EXIT"|"FOR"|"IF"|"IN"|"IS"|"LOOP"|"MOD"|"NOT"|"OF"|"OR"|"OUT"|"PROCEDURE"|"PROGRAM"|"READ"|"RECORD"|"RETURN"|"THEN"|"TO"|"TYPE"|"VAR"|"WHILE"|"WRITE")
DIGIT       [0-9]
DIGITS         {DIGIT}+
INTEGER     {DIGITS}
HEXDIGIT    [0-9A-Fa-f]
REAL        {DIGIT}+"."{DIGIT}*

STRING      \"([^"\n])*\"
ID          [a-zA-Z][a-zA-Z0-9]*
DELIMETER   (":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"[<"|">]"|'\')
OPERATOR    (":="|"+"|"-"|"*"|"/"|"<"|"<="|">"|">="|"="|"<>")

COMMENT    \(\*.*\*\)

%%

<<EOF>>         {
                        printf("\nNumber of tokens: %d", TokensNumber);
                        return T_EOF;
                }


{COMMENT}       PassN(row, col, "Comment  ", yytext);

{KEYWORDS}       TokenOutput(row, col, "Keyword  ", yytext);

{STRING}        TokenOutput(row, col, "String   ", yytext);

{OPERATOR}      TokenOutput(row, col, "Operator ", yytext);

{DELIMETER}     TokenOutput(row, col, "Delimeter", yytext);

{ID}            TokenOutput(row, col, "Identifer", yytext);

{INTEGER}       {
                        if(strlen(yytext) > 9 && atoi(yytext) == -1)
                        {
                                TokenOutput(row, col, "ERROR: Integer out of range", yytext);
                                return 1;
                        }
                        TokenOutput(row, col, "Integer  ", yytext);
                }

{REAL}          TokenOutput(row, col, "Real     ", yytext);


\n              {
                row++; col = 1;
                }   


.               col++;

%%

void TokenOutput(int& row, int& col, const char* type, char* text){

        printf("%d\t%d\t%s\t%s\n",
                        row, col, type ,text);
        col += strlen(text);
        TokensNumber++;

        return;
}

void PassN(int& row, int& col, const char* type, char* text){
	
        col += strlen(text);

        return;
}
    