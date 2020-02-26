open Yojson

val is_null : Yojson.Basic.json -> bool

val is_bool : Yojson.Basic.json -> bool

val is_int : Yojson.Basic.json -> bool

val is_float : Yojson.Basic.json -> bool

val is_string : Yojson.Basic.json -> bool

val is_assoc : Yojson.Basic.json -> bool

val is_list : Yojson.Basic.json -> bool


val to_bool : Yojson.Basic.json -> bool

val to_int : Yojson.Basic.json -> int

val to_float : Yojson.Basic.json -> float

val to_string : Yojson.Basic.json -> string

val to_list : Yojson.Basic.json -> Yojson.Basic.json list


val get : string -> Yojson.Basic.json -> Yojson.Basic.json


val from_file : string -> Yojson.Basic.json
