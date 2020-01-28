open Types
open ConfigState
open SatysfiSyntax


let add_paren str = "(" ^ str ^ ")"

(*
let tag tag_name opt_lst children =
  let blockCmd_lst = ConfigState.get_blockCmd () in
  let if_blockCmd = List.exists ((=) tag_name) blockCmd_lst in
  let blockCmdPro_lst = ConfigState.get_blockCmdPro () in
  let if_blockCmdPro = List.exists ((=) tag_name) blockCmdPro_lst in
  let inlineCmd_lst = ConfigState.get_inlineCmd () in
  let if_inlineCmd = List.exists ((=) tag_name) inlineCmd_lst in
    if if_blockCmd then
      "+" ^ tag_name ^ opt_lst ^ children ^ ";"
    else
      if if_blockCmdPro then
        "+" ^ tag_name ^ opt_lst ^ children ^ ";"
      else
        if if_inlineCmd then
          "\\" ^ tag_name ^ opt_lst ^ children ^ ";"
        else
          tag_name ^ opt_lst ^ children |> String.uncapitalize_ascii
*)

let get_satysfi_type t =
  match t with
  | SATySFiList(t') -> t'
  | _ -> t

let to_cmd btag tag_name =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:to_cmd")
  in
  let eq ((_,name),_,_) = (btag = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, t, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:to_cmd")
  in
  match get_satysfi_type satysfi_type with
  | SATySFiBlockText(_) -> "+" ^ tag_name
  | SATySFiInlineText(_) -> "\\" ^ tag_name
  | _ -> String.uncapitalize_ascii tag_name


let requirePackage () =
  let join s1 s2 = s1 ^ "\n" ^ s2 in
    ConfigState.get_requirePackage ()
    |> List.map (fun (pos, p) -> "@require: " ^ p)
    |> List.fold_left join ""


let importPackage () =
  let join s1 s2 = s1 ^ "\n" ^ s2 in
    ConfigState.get_importPackage ()
    |> List.map (fun (pos, p) -> "@import: " ^ p)
    |> List.fold_left join ""


let pcdata tag str =
(*
  let attrib_lst = ConfigState.get_attrib () in
  let tag_lst_pcdata_type_opt =
    try
      List.find (fun (tag, _, _) -> btag = tag) attrib_lst
        |> (fun (_, t, _) -> t)
    with
      | Not_found -> None
      | _ -> None
  in
  let tag_lst_pcdata_type =
    match tag_lst_pcdata_type_opt with
    | Some(t) -> t
    | None -> SATySFiString
  in
*)
    str



let set_attrib tag (attrib, var) =
  let attribs_lst = ConfigState.get_attrib () in
  let attrib_lst =
    try
      List.find (fun ((_, tag_name), _, _) -> tag_name = tag) attribs_lst
        |> (fun (_, _, lst) -> lst)
    with
    | Not_found -> []
  in
  let v =
    try
      List.find (fun ((_, attrib_name), _, _) -> attrib_name = attrib) attrib_lst
        |> (fun (_, satysfi_type, (_, n)) -> Some(SatysfiSyntax.from_type satysfi_type var, n))
    with
    | Not_found -> None
  in
    v


let type_paren tag_name str =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  let eq ((_,name),_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, t, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  SatysfiSyntax.from_type satysfi_type str |> add_paren


let type_paren_list tag_name str =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  let eq ((_,name),_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, t, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  SatysfiSyntax.from_type (get_satysfi_type satysfi_type) str |> add_paren


let type_semicolon tag_name =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  let eq ((_,name),_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, t, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  match satysfi_type with
  | SATySFiBlockText(_) -> ";"
  | SATySFiInlineText(_) -> ";"
  | _ -> ""


let is_list tag_name =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  let eq ((_,name),_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, t, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  match satysfi_type with
  | SATySFiList(_) -> true
  | _ -> false