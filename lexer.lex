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
RESERVED     ("AND"|"ARRAY"|"BEGIN"|"BY"|"DIV"|"DO"|"ELSE"|"ELSIF"|"END"|"EXIT"|"FOR"|"IF"|"IN"|"IS"|"LOOP"|"MOD"|"NOT"|"OF"|"OR"|"OUT"|"PROCEDURE"|"PROGRAM"|"READ"|"RECORD"|"RETURN"|"THEN"|"TO"|"TYPE"|"VAR"|"WHILE"|"WRITE")
DIGIT       [0-9]
DIGITS         {DIGIT}+
INTEGER     {DIGITS}
HEXDIGIT    [0-9A-Fa-f]
REAL        {DIGIT}+"."{DIGIT}*

STRING      \"([^"\n])*\"
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT})*
DELIMETER   (":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"[<"|">]"|'\')
OPERATOR    (":="|"+"|"-"|"*"|"/"|"<"|"<="|">"|">="|"="|"<>")

COMMENT    \(\*.*\*\)

%%

<<EOF>>         {
                        printf("\nNumber of tokens: %d", TokensNumber);
                        return T_EOF;
                }


{COMMENT}       PassN(row, col, "Comment  ", yytext);

{RESERVED}       TokenOutput(row, col, "Keyword  ", yytext);

{STRING}  {
    if(yyleng-2 < 256)
    {
        int i;
        for(i=1; i<yyleng-1; i++)
            if(!printable_ascii(yytext[i])) {
                yyerror_unknownchar(yytext[i]);
                return ERROR;
            }

        yylval.Tstring = create_cstr();
        return STRINGT; 
    }

    yyerror("String too long");
    return ERROR;
}

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
    