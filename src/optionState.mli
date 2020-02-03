
val set_input_file : string -> unit
val input_file : unit -> string option

val set_input_text : string -> unit
val input_text : unit -> string option

val is_file_mode : unit -> bool

val set_output_file : string -> unit
val output_file : unit -> string option

val set_config_file : string -> unit
val config_file : unit -> string option

val set_package : bool -> unit
val package : unit -> bool

val is_do_not_parse : unit -> bool