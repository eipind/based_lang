(* Based Laws  *)

type basedLaws = 
  | BasedT_int of int
  | BasedT_greater_than of basedLaws * basedLaws
  | BasedT_greater_eq of basedLaws * basedLaws
  | BasedT_less_than of basedLaws * basedLaws
  | BasedT_less_eq of basedLaws * basedLaws
  | BasedT_equals of basedLaws * basedLaws
  | BasedT_var of string
  | BasedT_assign of basedLaws * basedLaws
  | BasedT_while of basedLaws * basedLaws
  | BasedT_plus of basedLaws * basedLaws
  | BasedT_minus of basedLaws * basedLaws
  | BasedT_print of basedLaws
  | BasedT_print_newline 
  | BasedT_print_space
  | BasedT_stream of basedLaws * basedLaws
  |	BasedT_columns_size of int
  | BasedT_times of basedLaws * basedLaws
  | BasedT_divide of basedLaws * basedLaws
  | BasedT_if of basedLaws * basedLaws * basedLaws
  | BasedT_pow of basedLaws * basedLaws
  | BasedT_mod of basedLaws * basedLaws
  | BasedT_basedT of basedLaws
  | BasedT_basedTs of basedLaws * basedLaws
  | BasedT_amount
  | BasedT_amount2


