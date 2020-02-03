open Range

exception Lexer_error_range of Range.t
exception Parser_error
exception Config_err of string


val error_msg : (unit -> unit) -> unit