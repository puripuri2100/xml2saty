open Types
open ConfigState
open SatysfiSyntax


let add_paren str = "(" ^ str ^ ")"


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


let to_cmd btag tag_name =
  let blockCmd_lst = ConfigState.get_blockCmd () in
  let is_blockCmd = List.exists ((=) btag) blockCmd_lst in
  let blockCmdPro_lst = ConfigState.get_blockCmdPro () in
  let is_blockCmdPro = List.exists ((=) btag) blockCmdPro_lst in
  let inlineCmd_lst = ConfigState.get_inlineCmd () in
  let is_inlineCmd = List.exists ((=) btag) inlineCmd_lst in
    if is_blockCmd then
      "+" ^ tag_name
    else
      if is_blockCmdPro then
        "+" ^ tag_name
      else
        if is_inlineCmd then
          "\\" ^ tag_name
        else
          String.uncapitalize_ascii tag_name


let requirePackage () =
  let join s1 s2 = s1 ^ "\n" ^ s2 in
    ConfigState.get_requirePackage ()
    |> List.map (fun p -> "@require: " ^ p)
    |> List.fold_left join ""


let importPackage () =
  let join s1 s2 = s1 ^ "\n" ^ s2 in
    ConfigState.get_importPackage ()
    |> List.map (fun p -> "@import: " ^ p)
    |> List.fold_left join ""


let pcdata btag str =
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
      List.find (fun (tag_name, _, _) -> tag_name = tag) attribs_lst
        |> (fun (_, _, lst) -> lst)
    with
    | Not_found -> []
  in
  let v =
    try
      List.find (fun (attrib_name, _, _) -> attrib_name = attrib) attrib_lst
        |> (fun (_, satysfi_type, n) -> Some(SatysfiSyntax.from_type satysfi_type var, n))
    with
    | Not_found -> None
  in
    v


let type_paren tag_name str =
  let blockCmd_lst = ConfigState.get_blockCmd () in
  let is_blockCmd = List.exists ((=) tag_name) blockCmd_lst in
  let blockCmdPro_lst = ConfigState.get_blockCmdPro () in
  let is_blockCmdPro = List.exists ((=) tag_name) blockCmdPro_lst in
  let inlineCmd_lst = ConfigState.get_inlineCmd () in
  let is_inlineCmd = List.exists ((=) tag_name) inlineCmd_lst in
    if is_blockCmd then
      SatysfiSyntax.from_block_text str |> add_paren
    else
      if is_blockCmdPro then
        SatysfiSyntax.from_block_text_pro str |> add_paren
      else
        if is_inlineCmd then
          SatysfiSyntax.from_inline_text str |> add_paren
        else
          add_paren str


let type_semicolon tag_name =
  let blockCmd_lst = ConfigState.get_blockCmd () in
  let is_blockCmd = List.exists ((=) tag_name) blockCmd_lst in
  let blockCmdPro_lst = ConfigState.get_blockCmdPro () in
  let is_blockCmdPro = List.exists ((=) tag_name) blockCmdPro_lst in
  let inlineCmd_lst = ConfigState.get_inlineCmd () in
  let is_inlineCmd = List.exists ((=) tag_name) inlineCmd_lst in
    if is_blockCmd then
      ";"
    else
      if is_blockCmdPro then
       ";"
      else
        if is_inlineCmd then
          ";"
        else
          ""