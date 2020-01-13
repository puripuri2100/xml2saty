type satysfiType =
  | SATySFiFunction
  | SATySFiString
  | SATySFiBool
  | SATySFiInt
  | SATySFiFloat
  | SATySFiLength
  | SATySFiInlineText
  | SATySFiBlockText

type attribs = string * satysfiType option * ((string * satysfiType * int) list)

type term =
  | TmString of string
  | TmRequirePackage of string list * term
  | TmImportPackage of string list * term
  | TmBlockCmd of string list * term
  | TmBLockCmdPro of string list * term
  | TmInlineCmd of string list * term
  | TmComment of string * term
  | TmAttrib of attribs list * term
  | TmNull
  | TmEOF
  | TmWrong of string