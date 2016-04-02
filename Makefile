
OUTPUT_NAME = mysplinterpreter.exe

all: main

main: lexer.cmo parser.cmo run.cmo basedLaws.cmo
	
	ocamlc -o $(OUTPUT_NAME) str.cma lexer.cmo parser.cmo run.cmo basedLaws.cmo

lexer.cmo: lexer.ml parser.ml basedLaws.cmo
	ocamlc -c lexer.ml

parser.cmo: parser.ml basedLaws.cmo
	ocamlc -c parser.ml

run.cmo: run.ml basedLaws.cmo
	ocamlc -c run.ml

lexer.ml: basedLaws.cmo
	ocamllex Lexer.mll

parser.ml: parser.mli basedLaws.cmo
	ocamlc -c parser.mli

parser.mli: basedLaws.cmo
	ocamlyacc parser.mly

basedLaws.cmo: basedLaws.ml
	ocamlc -c BasedLaws.ml
clean:
	rm -f lexer.cmo
	rm -f parser.cmo
	rm -f run.cmo
	rm -f parser.mli
	rm -f parser.ml
	rm -f lexer.ml
	rm -f *.cmi
	rm -f basedLaws.cmo
