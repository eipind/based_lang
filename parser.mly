%{
  open BasedLaws
%}
%token <int> INT 
%token <string> VARNAME STRING
%token AMOUNT_OF_COLUMNS
%token AMOUNT_OF_ROWS
%token LPAREN RPAREN
%token IF DO ELSE WHILE
%token OPENSTREAM CLOSESTREAM COMMA SPEECH
%token PLUS TIMES DIV MINUS MOD POW SET GREATERTHAN GREATEREQ EQUALS LESSTHAN LESSEQ
%token TRUE FALSE
%token EOL 
%token EOF
%token PRINT PRINTSPACE PRINTNEWLINE
%nonassoc IF DO ELSE WHILE
%left PLUS MINUS TIMES DIV POW
%token BEGIN
%token LEFTBRACE RIGHTBRACE
%token DOLLAR 
%start based
%type <BasedLaws.basedLaws> based
%type <BasedLaws.basedLaws> statement
%type <BasedLaws.basedLaws> statements
%type <BasedLaws.basedLaws> body
%type <BasedLaws.basedLaws> while_stmt
%type <BasedLaws.basedLaws> if_stmt
%type <BasedLaws.basedLaws> aexpr
%type <BasedLaws.basedLaws> bexpr
%type <BasedLaws.basedLaws> cexpr
%type <BasedLaws.basedLaws> assign
%type <BasedLaws.basedLaws> booleeanne_expr
%type <BasedLaws.basedLaws> vari
%type <BasedLaws.basedLaws> ints
%type <BasedLaws.basedLaws> stream_stmt 


%%
based:
	
   BEGIN statements EOF	{ $2 }
;
statements:
            	| statement {BasedT_basedT($1)}
            	| statement statements {BasedT_basedTs($1,$2)} 
;
statement:
            body									{$1}
           
;


body:
            	| if_stmt DOLLAR DOLLAR						{$1}
            	| while_stmt DOLLAR	DOLLAR					{$1}
            	| expr DOLLAR 								{$1}
            	| assign DOLLAR								{$1}
				| print_stmt DOLLAR 						{$1}
				| stream_stmt DOLLAR 						{$1}
				
;
stream_stmt:
	| OPENSTREAM ints COMMA ints CLOSESTREAM 			{ BasedT_stream($2,$4) }
	| OPENSTREAM vari COMMA ints CLOSESTREAM 			{ BasedT_stream($2,$4) }
	| OPENSTREAM ints COMMA vari CLOSESTREAM 			{ BasedT_stream($2,$4) }
	| OPENSTREAM vari COMMA vari CLOSESTREAM 			{ BasedT_stream($2,$4) }
;
while_stmt:
	 WHILE booleeanne_expr DO statements  
								{BasedT_while($2, $4)}
if_stmt:
      IF booleeanne_expr DO statements ELSE statements {BasedT_if($2, $4, $6)}
;
print_stmt:	
	|PRINT LPAREN expr RPAREN			{BasedT_print ($3)}
	|PRINTNEWLINE LPAREN RPAREN			{BasedT_print_newline}
	|PRINTSPACE LPAREN RPAREN			{BasedT_print_space}
	;
booleeanne_expr:
            	| expr GREATERTHAN  expr   		{BasedT_greater_than ($1, $3)}
            	| expr GREATEREQ expr			{BasedT_greater_eq ($1, $3)}
				| expr LESSTHAN  expr   		{BasedT_less_than ($1, $3)}
            	| expr LESSEQ expr			{BasedT_less_eq ($1, $3)}
            	| expr EQUALS expr				{BasedT_equals($1, $3)}                                                                                           	
;

assign:
            	|vari SET ints			{ BasedT_assign($1,$3)}
				|vari SET stream_stmt	{ BasedT_assign($1,$3)}
            	|vari SET vari 			{ BasedT_assign($1,$3) }	
				|vari SET expr			{ BasedT_assign($1,$3) }
;
expr:
            	| LPAREN aexpr PLUS expr	RPAREN			{ BasedT_plus ($2,$4)}
            	| LPAREN aexpr MINUS expr RPAREN				{ BasedT_minus($2,$4) }
				| aexpr							{$1}
;
aexpr:
            	| LPAREN bexpr TIMES expr RPAREN				{ BasedT_times($2,$4)}
            	| LPAREN bexpr DIV	expr RPAREN			{ BasedT_divide($2,$4) }
				| bexpr						{ $1 }
;

bexpr:
            	| LPAREN cexpr MOD expr	RPAREN			{BasedT_mod($2,$4)}
				| LPAREN cexpr POW expr	RPAREN			{BasedT_pow($2,$4)}
            	| cexpr									{ $1 }
;
cexpr:
            	| LPAREN expr RPAREN                    { $2 }
            	| LPAREN ints RPAREN                    { $2 }
				| LPAREN vari RPAREN                    { $2 }
;
ints:
				| INT										{ BasedT_int $1 }
				| AMOUNT_OF_COLUMNS							{BasedT_amount}
				| AMOUNT_OF_ROWS							{BasedT_amount2}
;
vari:
				VARNAME                       			{ BasedT_var $1 }
;
