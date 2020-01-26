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

type attribs = (Range.t * string) * satysfiType option * (((Range.t * string) * satysfiType * (Range.t * int)) list)

type term =
  | TmString of string
  | TmRequirePackage of (Range.t * string) list * term
  | TmImportPackage of (Range.t * string) list * term
  | TmComment of (Range.t * string) * term
  | TmAttrib of attribs list * term
  | TmNull
  | TmEOF
  | TmWrong of string