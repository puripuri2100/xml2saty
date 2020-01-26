open Range
open Types

type state = {
  mutable requirePackage : (Range.t * string) list;
  mutable importPackage : (Range.t * string) list;
  mutable attrib : Types.attribs list;
}


let state = {
  requirePackage = [];
  importPackage = [];
  attrib = [];
}

let set_requirePackage lst =
  state.requirePackage <- lst

let get_requirePackage () =
  state.requirePackage


let set_importPackage lst =
  state.importPackage <- lst

let get_importPackage () =
  state.importPackage


let set_attrib lst =
  state.attrib <- lst

let get_attrib () =
  state.attrib


let set_all (term: Types.term) =
  let rec sub term =
    match term with
    | TmString(str) -> ()
    | TmRequirePackage(lst, term') ->
      let () = set_requirePackage lst in
        sub term'
    | TmImportPackage(lst, term') ->
      let () = set_importPackage lst in
        sub term'
    | TmAttrib(lst, term') ->
    let () = set_attrib lst in
      sub term'
    | TmComment(comment, term') -> sub term'
    | TmNull -> ()
    | TmEOF -> ()
    | TmWrong(msg) -> Printf.printf "%s\n" msg
  in
    sub term