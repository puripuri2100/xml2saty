open Types

type state

val set_requirePackage : string list -> unit

val get_requirePackage : unit -> string list

val set_importPackage : string list -> unit

val get_importPackage : unit -> string list

val set_blockCmd : string list -> unit

val get_blockCmd : unit -> string list

val set_blockCmdPro : string list -> unit

val get_blockCmdPro : unit -> string list

val set_inlineCmd :string list -> unit

val get_inlineCmd : unit -> string list

val set_attrib : Types.attribs list -> unit

val get_attrib : unit -> Types.attribs list

val set_all : Types.term -> unit