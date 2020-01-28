type t =
  | Dummy of string
  | Normal of string * int * int * int * int


let dummy msg = Dummy(msg)


let make fname ln pos1 pos2 =
  Normal(fname, ln, pos1, ln, pos2)

let make_large fname ln1 pos1 ln2 pos2 =
  Normal(fname, ln1, pos1, ln2, pos2)


let to_string rng =
  let s = string_of_int in
    match rng with
    | Dummy(msg) ->
        "dummy range '" ^ msg ^ "'"

    | Normal(fname, ln1, pos1, ln2, pos2) ->
        if ln1 = ln2 then
          "\"" ^ fname ^ "\", line " ^ (s ln1) ^ ", characters " ^ (s pos1) ^ "-" ^ (s pos2)
        else
          "\"" ^ fname ^ "\", line " ^ (s ln1) ^ ", character " ^ (s pos1) ^ " to line " ^ (s ln2) ^ ", character " ^ (s pos2)