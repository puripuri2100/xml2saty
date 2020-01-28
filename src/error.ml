open Range

exception Lexer_error_range of Range.t

exception Parser_error


type t =
  | Lexer
  | Parser


let print_error (t:t) str =
  let err_title =
    match t with
    | Lexer -> "Lexer"
    | Parser -> "Parser"
  in
  Printf.printf "![%sError]\n%s\n" err_title str

let error_msg t =
  try
    t ()
  with
    | Lexer_error_range(pos) ->
      let range = Range.to_string pos in
      print_error Lexer range