open Range

type satysfiType =
  | SATySFiFunction of Range.t
  | SATySFiString of Range.t
  | SATySFiBool of Range.t
  | SATySFiInt of Range.t
  | SATySFiFloat of Range.t
  | SATySFiLength of Range.t
  | SATySFiInlineText of Range.t
  | SATySFiBlockText of Range.t
  | SATySFiList of satysfiType


type attribs =
    (Range.t * string)
    * (Range.t * string) option
    * satysfiType option
    * (Range.t * int) option
    * (((Range.t * string)* satysfiType * (Range.t * int)) list)

type term =
  | TmString of string
  | TmRequirePackage of (Range.t * string) list * term
  | TmImportPackage of (Range.t * string) list * term
  | TmComment of (Range.t * string) list * term
  | TmAttrib of attribs list * term
  | TmModule of ((Range.t * string) * (Range.t * string)) * term
  | TmNull
  | TmEOF
  | TmWrong of string