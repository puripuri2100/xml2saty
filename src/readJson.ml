open Yojson
open Yojson.Basic
open Yojson.Basic.Util

type t =
  | JsonNull
  | JsonBool
  | JsonInt
  | JsonIntlit
  | JsonFloat
  | JsonFloatlit
  | JsonString
  | JsonStringlit
  | JsonAssoc
  | JsonList
  | JsonTuple
  | JsonVariant


let is_null json =
  match json with
  | `Null -> true
  | _ -> false

let is_bool json =
  match json with
  | `Bool(_) -> true
  | _ -> false

let is_int json =
  match json with
  | `Int(_) -> true
  | _ -> false

let is_float json =
  match json with
  | `Float(_) -> true
  | _ -> false

let is_string json =
  match json with
  | `String(_) -> true
  | _ -> false

let is_assoc json =
  match json with
  | `Assoc(_) -> true
  | _ -> false

let is_list json =
  match json with
  | `List(_) -> true
  | _ -> false



let to_bool = Yojson.Basic.Util.to_bool

let to_int = Yojson.Basic.Util.to_int

let to_float = Yojson.Basic.Util.to_float

let to_string = Yojson.Basic.Util.to_string


let to_list = Yojson.Basic.Util.to_list

let get tag json = Yojson.Basic.Util.member tag json


let from_file path =
  Yojson.Basic.from_file path

