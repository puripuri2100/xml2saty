%{
  open Types
%}

%token SATySFiFunction SATySFiString SATySFiBool SATySFiInt SATySFiFloat SATySFiLength SATySFiInlineText SATySFiBlockText
%token LPAREN RPAREN
%token LBRAC RBRAC
%token Colon SemiColon Comma
%token Attrib
%token LComment RComment
%token DoubleQuotation
%token <string>String
%token <int>Int
%token <string>Path
%token Require Import BlockCmd BlockCmdPro InlineCmd
%token EOF

%start parse
%type <Types.term> parse

%%

parse :
  | term EOF { $1 }
;
satysfiType :
  | SATySFiFunction {SATySFiFunction}
  | SATySFiString {SATySFiString}
  | SATySFiBool {SATySFiBool}
  | SATySFiInt {SATySFiInt}
  | SATySFiFloat {SATySFiFloat}
  | SATySFiLength {SATySFiLength}
  | SATySFiInlineText {SATySFiInlineText}
  | SATySFiBlockText {SATySFiBlockText}
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
  | BlockCmd Colon str_lst term { TmBlockCmd($3, $4)  }
  | BlockCmdPro Colon str_lst term { TmBLockCmdPro($3, $4)  }
  | InlineCmd Colon str_lst term { TmInlineCmd($3, $4)  }
  | Attrib Colon attribs_lst term {TmAttrib($3, $4)}
  | LComment String RComment term { TmComment($2, $4) }
  | LPAREN term RPAREN {$2}
  | EOF {TmEOF}
;
%%
