open Range

exception Lexer_error_range of Range.t
exception Parser_error
exception Config_error of string
exception Option_error of string


val error_msg : (unit -> unit) -> unit