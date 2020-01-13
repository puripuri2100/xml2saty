{
  open Parse
}

let space = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']
let alpha = ( ['a'-'z'] | ['A'-'Z'] )
let symbol = ( [' '-'@'] | ['['-'`'] | ['{'-'~'] )
let opsymbol = ( '+' | '-' | '*' | '/' | '^' | '&' | '|' | '!' | ':' | '=' | '<' | '>' | '~' | '\'' | '.' | '?' )
let alnum = digit | alpha
let string = ( alnum | '.' | '/' | '-' )

rule lex = parse
  | space+   { lex lexbuf }
  | "function" {SATySFiFunction}
  | "string" {SATySFiString}
  | "bool" {SATySFiBool}
  | "int" {SATySFiInt}
  | "float" {SATySFiFloat}
  | "length" {SATySFiLength}
  | "inline-text" {SATySFiInlineText}
  | "block-text" {SATySFiBlockText}
  | "\"" {DoubleQuotation}
  | '(' {LPAREN}
  | ')' {RPAREN}
  | '[' {LBRAC}
  | ']' {RBRAC}
  | ':' {Colon}
  | ';' {SemiColon}
  | ',' {Comma}
  | "require" {Require}
  | "import" {Import}
  | "block-cmd" {BlockCmd}
  | "block-cmd-pro" {BlockCmdPro}
  | "inline-cmd" {InlineCmd}
  | "attrib" {Attrib}
  | "(*" {LComment}
  | "*)" {RComment}
  | digit+ as n {Int(int_of_string n)}
  | string+ as str {String(str)}
  | eof {EOF}
 