open ReadJson
open Types
open Range

let dummy_range_require = Range.dummy "json require"

let dummy_range_import = Range.dummy "json import"

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


let read_json_file path =
  let json_t = ReadJson.from_file path in
  let require_types_list = get_json_require_list json_t in
  let import_types_list = get_json_import_list json_t in
  TmRequirePackage(require_types_list,
    TmImportPackage(import_types_list,TmNull)
  )