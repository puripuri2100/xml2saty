open String
open Types

let from_inline_text it =
  "{" ^ it ^ "}"


let from_block_text  bt =
   "<" ^ bt ^ ">"

let from_block_text_pro  bt =
   "'<" ^ bt ^ ">"


let from_string  str =
  let count = ref 0 in
  let rec sub str num =
    if (String.length str) <= 0 then
      !count
    else
      let str_len = String.length str in
      let str_head = String.sub str 0 1 in
      let str_tail = String.sub str 1 (str_len - 1) in
      if ("`") = str_head then
        sub str_tail (num + 1)
      else
        if num > !count then
          let () = count := num in
            sub str_tail 0
        else
          sub str_tail 0
  in
  let back_quote =
    let n = (sub str 0) + 1 in
      String.make n '`'
  in
    back_quote ^ " " ^ str ^ " " ^ back_quote

let from_int  n =
  string_of_int n

let to_int s =
  int_of_string s |> from_int

let from_float  fl =
  string_of_float fl

let to_float s =
  float_of_string s |> from_float

let from_bool b =
  string_of_bool b

let to_bool s =
  bool_of_string s |> from_bool

(*
let from_length  len =
  show_float (len /' 1pt) ^ "pt"
*)

(*
let from_color  color =
  let to_tuple_f f lst =
    List.map f lst |> to_tuple
  in
  match color with
  | Gray(f) _> "Gray(" ^ show_float f  ^ ")"
  | RGB(r, g, b) _> "RGB(" ^ to_tuple_f show_float [r;g;b] ^ ")"
  | CMYK(c, m, y, k) _> "CMYK(" ^ to_tuple_f show_float [c;m;y;k] ^ ")"
*)

let from_type satysfi_type str =
  let f =
  match satysfi_type with
    | SATySFiString -> from_string
    | SATySFiBool -> to_bool
    | SATySFiInt -> to_int
    | SATySFiFloat -> to_float
    | SATySFiInlineText -> from_inline_text
    | SATySFiBlockText -> from_block_text
    | _ -> from_string
  in
    f str