open BasedLaws;;
open Parser;;
open Lexer;;
open List;;
open Arg;;
exception Unbound2_Variable of (string);;
 let rec pow n m = match m with 
      0 -> 1 
    | m when (m < 0) -> 0
    | m -> n * pow n (m-1)  ;;
let entryPointSet = ref false;;
let entryPoint = ref (BasedT_int (0));;
module Vars = Map.Make(String);;
let global = ref Vars.empty;;
let columns = ref [[""]];;

let rec ev basedT =
  let evStatements statement statements =
    ignore (ev statement);
    ev statements
  in
  let evStatement statement =
    (ev statement)
  in
  let evVar name =
    try
      Vars.find name !global
    with Not_found -> 
		raise (Unbound2_Variable name)
  in
  let evPrint ar = 
    print_int (ev ar);
	0
  in
  let evAssign name value =
      global := Vars.add name (ev value) !global;
	  0
  in
  let evIf cond first sec =
    ignore (if (ev cond)!= 0 then ev first else ev sec); 0
  in
  let evWhile cond body =
     while ((ev cond)!=0) do
            ignore (ev body);
        done;
        0
  in
  let updateEntryPoint basedT =
    (entryPoint := basedT);
    (entryPointSet := true);
	ignore 0
  in
  let getSize = List.length (List.nth !columns 0)  in
  let getSize2 =   (List.length !columns) in
  let evStream i j = 
	int_of_string (List.nth (List.nth !columns i) j);
  in
  match basedT with
  |BasedT_basedT(ar) -> if !entryPointSet == false then updateEntryPoint basedT else ignore 0; evStatement ar
  |BasedT_basedTs(ar1, ar2) -> if (!entryPointSet == false) then (updateEntryPoint basedT) else ignore 0; (evStatements ar1 ar2)
  |BasedT_plus(ar1, ar2) -> (ev ar1) + (ev ar2)
  |BasedT_minus(ar1, ar2) -> (ev ar1) - (ev ar2)
  |BasedT_times(ar1, ar2) -> (ev ar1) * (ev ar2)
  |BasedT_divide(ar1, ar2) -> (ev ar1) / (ev ar2)
  |BasedT_pow(ar1, ar2) -> (pow (ev ar1) (ev ar2))
  |BasedT_mod(ar1, ar2) -> (ev ar1) mod (ev ar2)
  |BasedT_print(ar) -> evPrint ar
  |BasedT_if(ar1, ar2, ar3) -> evIf ar1 ar2 ar3
  |BasedT_while(ar1, ar2) -> evWhile ar1 ar2
  |BasedT_equals(ar1, ar2) -> if ((ev ar1) == (ev ar2)) then 1 else 0
  |BasedT_less_than(ar1, ar2) -> if ((ev ar1) < (ev ar2)) then 1 else 0
  |BasedT_less_eq(ar1, ar2) -> if ((ev ar1) <= (ev ar2)) then 1 else 0
  |BasedT_greater_than(ar1, ar2) -> if ((ev ar1) > (ev ar2)) then 1 else 0
  |BasedT_greater_eq(ar1, ar2) -> if ((ev ar1) >= (ev ar2)) then 1 else 0
  |BasedT_int(ar) -> ar
  |BasedT_assign(BasedT_var(ar1), ar2) -> evAssign ar1 ar2
  |BasedT_amount -> getSize;
  |BasedT_amount2 -> getSize2;
  |BasedT_assign(_, ar2) -> print_string "error!!! Incorrect Assignment." ;(exit 0);
  |BasedT_var(ar) -> evVar ar;
  |BasedT_stream(ar1, ar2) -> evStream (ev ar1) (ev ar2)
  |BasedT_print_newline  -> print_newline()	;0
  |BasedT_print_space -> print_string " ";0
  |_ -> print_string "error!!!" ;(exit 0)
 ;;




let process_file process channelref =
    let ch = !channelref in
    try while true do process(input_line ch) done
    with End_of_file -> close_in ch;;

	
let input arg lines =
		let addingLines lnne = lines := !lines ^ "\n" ^ lnne in
		let () = process_file addingLines arg in
			let lineslst = Str.split (Str.regexp "\n") !lines in
			for j=0 to (List.length lineslst)-1 do
				let lne = ref (List.nth lineslst j) in
					let ln =  (Str.split (Str.regexp " ") !lne) in
						let clmn = ref [] in
							for k=0 to ((List.length ln)-1) do
							clmn := (List.nth ln k)::!clmn;
							done;
							columns:= List.rev !clmn :: !columns;
				done
;;




(*let input =
		let lines = (ref "") in
				while true do
					(lines := !lines ^ "\n" ^ read_line())
				done;
				
				let lineslst = (Str.split (Str.regexp "\n") !lines ) in
						for j=0 to (List.length lineslst) do
							for k=0 to (String.length (List.nth lineslst 0)) do
								let clmn = ref (List.nth !columns k) in
								clmn:= (int_of_char (String.get (List.nth lineslst j) k)) :: !clmn
							done
						done;
						for k=0 to (List.length !columns) do
						let clmn2 = ref (List.nth !columns k) in
							(clmn2:= List.rev !clmn2)
						done
;;*)
  
  let parseProgram c = 
    try let lexbuf = Lexing.from_channel c in  
            based language lexbuf 
    with Parsing.Parse_error -> failwith "Parse failure!" ;;


let arg = ref stdin in
	ignore (input arg (ref ""));
	let setProg p = arg := open_in p in
	let () = columns:= List.tl ( List.rev !columns ) in
	let usage = "./run PROGRAM_FILE" in
	parse [] setProg usage ; 
	print_string "Program Starting..." ;
	print_newline();
	let parsedProg = parseProgram !arg in
	let () = print_string "Program Parsed" ; print_newline() in
	let () = ignore(ev parsedProg) in 
	let () = print_newline() in 
flush stdout
