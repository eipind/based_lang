(* file lexer.mll*)
{
open Parser
}
rule language = parse	
		| [' ' '\t']							{ language lexbuf }     (* skip blanks *)
    	| ['\n' ]								{ language lexbuf } (* new line *)
    	| ['0'-'9']+ as int 					{ INT(int_of_string int) }
    	| '+'      								{ PLUS }
    	| '-'      								{ MINUS }
    	| '*'      								{ TIMES }
    	| '/'      								{ DIV }
    	| '^' 	     							{ POW }
    	| '%'      								{ MOD }
    	| "printing"							{ PRINT }
		| '"'									{ SPEECH }
		|"print_newline"						{PRINTNEWLINE}
		| "print_space"							{PRINTSPACE}
		| "amount_of_columns"					{ AMOUNT_OF_COLUMNS }
		| "amount_of_rows"					{ AMOUNT_OF_ROWS }
    	| '('      								{ LPAREN }
    	| ')'      								{ RPAREN }
    	| '$'      								{ DOLLAR } 
    	| "if"     								{ IF }
		| ','									{ COMMA }
    	| "do" 									{ DO }
    	| "tru"									{ TRUE }
    	| "else"   								{ ELSE }
    	| "while"  								{ WHILE }
    	| '<'      								{ LESSTHAN } 
    	| "<="     								{ LESSEQ }
		| '>'      								{ GREATERTHAN } 
    	| ">="     								{ GREATEREQ }
    	| "=="    								{ EQUALS }
    	| '='      								{ SET }
		| '{'									{ LEFTBRACE }
		| '}'									{ RIGHTBRACE }
    	| ['A'-'Z''a'-'z''0'-'9']+ as name		{ VARNAME(name) }
		| "ba$ed"								{ BEGIN }
		| "wavy["								{ OPENSTREAM }
		| "]dude"								{ CLOSESTREAM }
		| ['0'-'9']+ as row 					{ INT(int_of_string row) }
    	| eof      								{ EOF }


(* no less than or less than or equal to because we decided it was unneccesary as you could switch variables in the greater than statements *)