%{
  open Range
  open Types
  open Error
%}

%token <Range.t>SATySFiFunction
%token <Range.t>SATySFiString
%token <Range.t>SATySFiBool
%token <Range.t>SATySFiInt
%token <Range.t>SATySFiFloat
%token <Range.t>SATySFiLength
%token <Range.t>SATySFiInlineText
%token <Range.t>SATySFiBlockText
%token <Range.t> SATySFiList
%token <Range.t>LPAREN
%token <Range.t>RPAREN
%token <Range.t>LBRAC
%token <Range.t>RBRAC
%token <Range.t>SemiColon
%token <Range.t>Comma
%token <Range.t>LComment
%token <Range.t>RComment
%token <Range.t>DoubleQuotation
%token <Range.t * string>String
%token <Range.t * int>Int
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
satysfiType_cont :
  | SATySFiFunction {SATySFiFunction($1)}
  | SATySFiString {SATySFiString($1)}
  | SATySFiBool {SATySFiBool($1)}
  | SATySFiInt {SATySFiInt($1)}
  | SATySFiFloat {SATySFiFloat($1)}
  | SATySFiLength {SATySFiLength($1)}
  | SATySFiInlineText {SATySFiInlineText($1)}
  | SATySFiBlockText {SATySFiBlockText($1)}
;
satysfiType :
  | satysfiType_cont SATySFiList {SATySFiList($1)}
  | satysfiType_cont {$1}
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
comment_cont:
  | {[]}
  | String {[$1]}
  | String comment_cont {$1 :: $2}
;
comment:
  | LComment comment_cont RComment {$2}
;
term :
  | Require str_lst term { TmRequirePackage($2, $3)  }
  | Import str_lst term { TmImportPackage($2, $3)  }
  | Attrib attribs_lst term {TmAttrib($2, $3)}
  | comment term { TmComment($1, $2) }
  | LPAREN term RPAREN {$2}
  | EOF {TmEOF}
;
%%
