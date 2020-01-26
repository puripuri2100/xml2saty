%{
  open Range
  open Types
%}

%token <Range.t>SATySFiFunction
%token <Range.t>SATySFiString
%token <Range.t>SATySFiBool
%token <Range.t>SATySFiInt
%token <Range.t>SATySFiFloat
%token <Range.t>SATySFiLength
%token <Range.t>SATySFiInlineText
%token <Range.t>SATySFiBlockText
%token <Range.t>LPAREN
%token <Range.t>RPAREN
%token <Range.t>LBRAC
%token <Range.t>RBRAC
%token <Range.t>Colon
%token <Range.t>SemiColon
%token <Range.t>Comma
%token <Range.t>LComment
%token <Range.t>RComment
%token <Range.t>DoubleQuotation
%token <Range.t * string>String
%token <Range.t * int>Int
%token <Range.t * string>Path
%token <Range.t>Require
%token <Range.t>Import
%token <Range.t>Attrib
%token EOF

%start parse
%type <Types.term> parse

%%

parse :
  | term EOF { $1 }
;
satysfiType :
  | SATySFiFunction {SATySFiFunction($1)}
  | SATySFiString {SATySFiString($1)}
  | SATySFiBool {SATySFiBool($1)}
  | SATySFiInt {SATySFiInt($1)}
  | SATySFiFloat {SATySFiFloat($1)}
  | SATySFiLength {SATySFiLength($1)}
  | SATySFiInlineText {SATySFiInlineText($1)}
  | SATySFiBlockText {SATySFiBlockText($1)}
;
str_lstcont:
  | { [] }
  | String { [$1] }
  | String SemiColon str_lstcont { $1 :: $3 }
;
str_lst:
  | LBRAC str_lstcont RBRAC { $2 }
;
attrib :
  | LPAREN String Comma satysfiType Comma Int RPAREN {$2, $4, $6}
;
attrib_lstcont:
  | { [] }
  | attrib { [$1] }
  | attrib SemiColon attrib_lstcont { $1 :: $3 }
;
attrib_lst:
  | LBRAC attrib_lstcont RBRAC { $2 }
;
attribs :
  | String attrib_lst {$1,None , $2}
  | String LPAREN satysfiType RPAREN attrib_lst {$1, Some($3), $5}
;
attribs_lstcont:
  | { [] }
  | attribs { [$1] }
  | attribs SemiColon attribs_lstcont { $1 :: $3 }
;
attribs_lst:
  | LBRAC attribs_lstcont RBRAC { $2 }
;
term :
  | Require Colon str_lst term { TmRequirePackage($3, $4)  }
  | Import Colon str_lst term { TmImportPackage($3, $4)  }
  | Attrib Colon attribs_lst term {TmAttrib($3, $4)}
  | LComment String RComment term { TmComment($2, $4) }
  | LPAREN term RPAREN {$2}
  | EOF {TmEOF}
;
%%
