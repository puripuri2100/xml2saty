open Range

exception Lexer_error_range of Range.t
exception Parser_error

val error_msg : (unit -> unit) -> unit