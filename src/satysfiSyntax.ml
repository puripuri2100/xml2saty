open Range
open String
open Types

let fold_lefti f init lst =
  let rec sub i f init lst =
    match lst with
    | [] -> init
    | x :: xs -> sub (i + 1) f (f i init x) xs
  in
  sub 0 f init lst


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
  n

let to_int s =
  s

let from_float  fl =
  fl

let to_float s =
  s

let from_bool b =
  b

let to_bool s =
  s

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


let to_satysfi_list t =
  let join i s1 s2 =
    if i == 0 then
      s2
    else
      s1 ^ ";\n" ^ s2
  in
let l = fold_lefti join "" t in
    "[\n" ^ l ^ "\n]"

let rec from_type satysfi_type str =
  match satysfi_type with
    | SATySFiString(_) -> from_string str
    | SATySFiBool(_) -> to_bool str
    | SATySFiInt(_) -> to_int str
    | SATySFiFloat(_) -> to_float str
    | SATySFiInlineText(_) -> from_inline_text str
    | SATySFiBlockText(_) -> from_block_text_pro str
    | SATySFiFunction(_) -> str
    | _ -> str