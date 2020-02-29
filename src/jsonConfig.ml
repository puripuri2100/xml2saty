open ReadJson
open Types
open Range

let dummy_range_require = Range.dummy "json require"

let dummy_range_import = Range.dummy "json import"

let dummy_range_attrib = Range.dummy "json attrib"

let to_satysfi_type s =
  match s with
  | "string" -> Types.SATySFiString(dummy_range_attrib)
  | "int" -> Types.SATySFiInt(dummy_range_attrib)
  | "float" -> Types.SATySFiFloat(dummy_range_attrib)
  | "bool" -> Types.SATySFiBool(dummy_range_attrib)
  | "function" -> Types.SATySFiBool(dummy_range_attrib)
  | "inline-text" -> Types.SATySFiInlineText(dummy_range_attrib)
  | "block-text" -> Types.SATySFiBlockText(dummy_range_attrib)
  | "string list" -> Types.SATySFiList(Types.SATySFiString(dummy_range_attrib))
  | "int list" -> Types.SATySFiList(Types.SATySFiInt(dummy_range_attrib))
  | "float list" -> Types.SATySFiList(Types.SATySFiFloat(dummy_range_attrib))
  | "bool list" -> Types.SATySFiList(Types.SATySFiBool(dummy_range_attrib))
  | "function list" -> Types.SATySFiList(Types.SATySFiBool(dummy_range_attrib))
  | "inline-text list" -> Types.SATySFiList(Types.SATySFiInlineText(dummy_range_attrib))
  | "block-text list" -> Types.SATySFiList(Types.SATySFiBlockText(dummy_range_attrib))
  | _ -> Types.SATySFiFunction(dummy_range_attrib)


let get_json_require_list json =
  json
  |> ReadJson.get "require" 
  |> ReadJson.to_list
  |> List.map ReadJson.to_string
  |> List.map (fun s -> (dummy_range_require, s))


let get_json_import_list json =
  json
  |> ReadJson.get "import" 
  |> ReadJson.to_list
  |> List.map ReadJson.to_string
  |> List.map (fun s -> (dummy_range_import, s))


let get_json_attrib_list json =
  let get_tag t =
    let t' =
      t
      |> ReadJson.get "tag"
      |> ReadJson.to_string
    in
      (dummy_range_attrib,t')
  in
  let get_rename t =
    let t' _ =
      t
      |> ReadJson.get "rename"
      |> ReadJson.to_string
    in
    try 
      Some((dummy_range_attrib,t' ()))
    with
    | _ -> None
  in
  let get_type t =
    let t' _ =
      t
      |> ReadJson.get "type"
      |> ReadJson.to_string
    in
    try 
      Some(to_satysfi_type (t'()))
    with
    | _ -> None
  in
  let get_len t =
    let t' _ =
      t
      |> ReadJson.get "len"
      |> ReadJson.to_int
    in
    try 
      Some((dummy_range_attrib,t' ()))
    with
    | _ -> None
  in
  let get_attribs t =
    let get_tag t =
      let t' _ =
        t
        |> ReadJson.get "tag"
        |> ReadJson.to_string
      in
      (dummy_range_attrib,t' ())
    in
    let get_type t =
      let t' =
        t
        |> ReadJson.get "type"
        |> ReadJson.to_string
      in
      to_satysfi_type t'
    in
    let get_num t =
      let t' _ =
        t
        |> ReadJson.get "num"
        |> ReadJson.to_int
      in
      (dummy_range_attrib,t' ())
    in
    t
    |> ReadJson.get "attribs"
    |> ReadJson.to_list
    |> List.map (fun j -> (get_tag j, get_type j, get_num j))
  in
  let get_t t =
    let a_tag = get_tag t in
    let a_rename = get_rename t in
    let a_type = get_type t in
    let a_len = get_len t in
    let a_attribs = get_attribs t in
    (a_tag, a_rename, a_type, a_len, a_attribs)
  in
  json
  |> ReadJson.get "attrib" 
  |> ReadJson.to_list
  |> List.map get_t


let read_json_file path =
  let json_t = ReadJson.from_file path in
  let require_types_list = get_json_require_list json_t in
  let import_types_list = get_json_import_list json_t in
  let attrib_types_list = get_json_attrib_list json_t in
  TmRequirePackage(require_types_list,
    TmImportPackage(import_types_list,
    TmAttrib(attrib_types_list,TmNull)
    )
  )