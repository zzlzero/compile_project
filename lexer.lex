%{
#include "lexer.h"

void output(const char* type, char* text);
void error_caller(const char* type);
int row = 1;
int col = 1;
int num = 0;
%}
%option     nounput
%option     noyywrap

WHITESPACE  [\ ]
COMMENT    \(\*.*\*\)
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

%%

{WHITESPACE} col++;
<<EOF>>         {
                printf("\nNumber of tokens: %d\n", num);
                return T_EOF;
        }


{COMMENT}       col += yyleng;

{RESERVED}       output("reserved keyword", yytext);

{STRING}  {
    if(yyleng-2 < 256) output( "string          ",yytext);

   else  error_caller("String too long");
}

{OPERATOR}      output("operator        ", yytext);

{DELIMETER}     output("delimeter       ", yytext);

{ID}            output("identifer       ", yytext);

{INTEGER}       {
                        if(strlen(yytext) > 9 && atoi(yytext) == -1)
                        {
                                error_caller("Integer out of range");
                                return 1;
                        }
                        else output("integer         ", yytext);
                }

{REAL}          output("real            ", yytext);


\n   {
        row++; 
        col = 1;
        }   


.               col++;

%%

void output(const char* type, char* text){

        printf("%d\t%d\t%s\t%s\n",  row, col, type, text);
        col += yyleng;
        num++;

        return;
}

void error_caller(const char* type){
        printf("%d\t%d\tERROR: %s\n",  row, col, type);
        col += yyleng;
        num++;
        return ;
}

    