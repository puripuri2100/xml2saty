open Types
open ConfigState
open SatysfiSyntax

val to_cmd : string -> string -> string

val requirePackage : unit -> string

val importPackage : unit -> string

val pcdata : string -> string -> string

val set_attrib : string -> string * string -> (string * int) option

val type_paren : string -> string -> string

val type_semicolon : string -> string