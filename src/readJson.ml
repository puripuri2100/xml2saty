open Yojson
open Types

let read_json_file path =
  let json_t = Yojson.Basic.from_file path in
  let s = Yojson.Basic.to_string json_t |> Printf.printf "%s\n" in
  TmNull
