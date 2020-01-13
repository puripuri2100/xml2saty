open Types

type state = {
  mutable requirePackage : string list;
  mutable importPackage : string list;
  mutable blockCmd : string list;
  mutable blockCmdPro : string list;
  mutable inlineCmd : string list;
  mutable attrib : Types.attribs list;
}


let state = {
  requirePackage = [];
  importPackage = [];
  blockCmd = [];
  blockCmdPro = [];
  inlineCmd = [];
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


let set_blockCmd lst =
  state.blockCmd <- lst

let get_blockCmd () =
  state.blockCmd


let set_blockCmdPro lst =
  state.blockCmdPro <- lst

let get_blockCmdPro () =
  state.blockCmdPro


let set_inlineCmd lst =
  state.inlineCmd <- lst

let get_inlineCmd () =
  state.inlineCmd


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
    | TmBlockCmd(lst, term') ->
      let () = set_blockCmd lst in
        sub term'
    | TmBLockCmdPro(lst, term') ->
      let () = set_blockCmdPro lst in
        sub term'
    | TmInlineCmd(lst, term') ->
      let () = set_inlineCmd lst in
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