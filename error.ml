
type t =
  | All of string


let to_string err =
    match err with
    | All(str) -> "![Error] "^ str


let print_error err =
(*
  failwith "%s\n" (err |> to_string)
*)
  Printf.printf "%s\n" (err |> to_string)


let make_error_all str =
  All(str)