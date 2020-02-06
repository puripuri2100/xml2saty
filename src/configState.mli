open Range
open Types

type state

val set_requirePackage : (Range.t * string) list -> unit

val get_requirePackage : unit -> (Range.t * string) list

val set_importPackage : (Range.t * string) list -> unit

val get_importPackage : unit -> (Range.t * string) list

val set_attrib : Types.attribs list -> unit

val get_attrib : unit -> Types.attribs list

val set_all : Types.term -> unit