open Str
open Types
open ConfigState
open SatysfiSyntax


let add_paren str = "(" ^ str ^ ")"


let get_satysfi_type t =
  match t with
  | SATySFiList(t') -> t'
  | _ -> t

let to_cmd btag tag_name =
  let get_opt d o =
    match o with
    | Some(v) -> v
    | None -> d
  in
  let eq_old ((_,name),_,_,_,_) = (btag = name) in
  let eq_new ((_,name),_,_,_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try
      List.find eq_old attrib_lst
      |> (fun (_, _, t,_, _) -> t)
      |> get_opt (SATySFiFunction(Range.dummy "ConfigApply:to_cmd"))
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:to_cmd")
  in
  let new_tag_name_opt =
    try
      List.find eq_new attrib_lst
      |> (fun (_, opt, _,_, _) -> opt)
    with _ -> None
  in
  let new_tag_name =
    match new_tag_name_opt with
    | Some((_,s)) -> s
    | None -> tag_name
  in
  match get_satysfi_type satysfi_type with
  | SATySFiBlockText(_) -> "+" ^ new_tag_name
  | SATySFiInlineText(_) -> "\\" ^ new_tag_name
  | _ -> String.uncapitalize_ascii new_tag_name


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


let pcdata btag str =
  let eq ((_,name),_,_,_,_) = (btag = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let is_inline_text =
    try
      let t =
        List.find eq attrib_lst
        |> (fun (_, _, t,_, _) -> t)
      in
      match t with
      | Some(SATySFiInlineText(_)) -> true
      | _ -> false
    with _ -> false
  in
    if not is_inline_text then
      str
    else
      (*
        一文字ずつ読んでエスケープ
        {,},<,>,%,$,#.\,;,|,*,@
      *)
      let rec sub head tail =
        if (String.length tail) <= 0 then
          head
        else
        let str_len =
          String.length tail
        in
        let str_head =
          String.sub tail 0 1
        in
        let str_tail =
          String.sub tail 1 (str_len - 1)
        in
        let is_escape s =
          let escape_string =
            ["{";"}";"<";">";"%";"$";"#";"\\";";";"|";"*";"@"]
          in
            List.exists ((=) s) escape_string
        in
        if is_escape str_head then
          sub (head ^ "\\" ^ str_head) str_tail
        else
          sub (head ^ str_head) str_tail
      in
        sub "" str


let set_attrib tag lst =
  let attribs_lst = ConfigState.get_attrib () in
  let (attrib_lst, size_opt) =
    try
      List.find (fun ((_, tag_name), _,_, _, _) -> tag_name = tag) attribs_lst
        |> (fun (_, _, _, n, lst) -> (lst,n))
    with
    | Not_found -> ([],None)
  in
  let size =
    match size_opt with
    | None -> List.length attrib_lst
    | Some(_,n) ->
      if n < 0 then
        List.length attrib_lst
      else
        n
  in
  let initial_array:(string option) array = Array.make (size) None in
  let f (attrib,var) =
    try
      List.find (fun ((_, attrib_name), _, _) -> attrib_name = attrib) attrib_lst
        |> (fun (_, satysfi_type, (_, n)) ->
          if n > size || n <= 0 then
            ()
          else
            initial_array.(n - 1) <- Some(SatysfiSyntax.from_type satysfi_type var)
        )
    with
    | Not_found -> ()
  in
  let () = List.iter f lst in
  let show_opt opt =
    match opt with
    | None -> "None"
    | Some(str) -> "Some"^(add_paren str)
  in
  Array.map show_opt initial_array |> Array.to_list


let type_paren tag_name str =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  let eq ((_,name),_,_,_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, _, t,_, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  SatysfiSyntax.from_type satysfi_type str |> add_paren


let type_paren_list tag_name str =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  let eq ((_,name),_,_,_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, _, t,_, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_paren")
  in
  SatysfiSyntax.from_type (get_satysfi_type satysfi_type) str |> add_paren


let type_semicolon tag_name =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  let eq ((_,name),_,_,_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, _, t, _, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  match satysfi_type with
  | SATySFiBlockText(_) -> ";"
  | SATySFiInlineText(_) -> ";"
  | SATySFiList(SATySFiBlockText(_)) -> ";"
  | SATySFiList(SATySFiInlineText(_)) -> ";"
  | _ -> ""


let is_list tag_name =
  let get_opt o =
    match o with
    | Some(v) -> v
    | None -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  let eq ((_,name),_,_,_,_) = (tag_name = name) in
  let attrib_lst = ConfigState.get_attrib () in
  let satysfi_type =
    try List.find eq attrib_lst |> (fun (_, _, t, _, _) -> t) |> get_opt
    with _ -> SATySFiFunction(Range.dummy "ConfigApply:type_semicolon")
  in
  match satysfi_type with
  | SATySFiList(_) -> true
  | _ -> false