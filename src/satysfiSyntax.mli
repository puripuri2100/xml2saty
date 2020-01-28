open String
open Types

val from_inline_text : string -> string

val from_block_text : string -> string

val from_block_text_pro : string -> string

val from_string : string -> string

val from_int : string -> string

val from_float : string -> string

val from_type : Types.satysfiType -> string -> string

val to_satysfi_list : string list -> string