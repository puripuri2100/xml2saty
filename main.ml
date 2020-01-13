open Xml
open Arg
open String
open Str
open Printf
open Filename
open Lexing

open Types
open Parse
open Lex
open Error
open OptionState
open SatysfiSyntax
open ConfigState
open ConfigApply


let option_from x opt =
  match opt with
  | Some(a) -> a
  | None -> x


let add_paren str = "(" ^ str ^ ")"


let rec show_option lst =
  match lst with
  | [] -> []
  | Some(x) :: xs -> x :: show_option xs
  | None :: xs -> show_option xs


let ord_int n1 n2 =
  if n1 = n2 then
    0
  else
    if n1 > n2 then
      1
    else
      -1

let join_str s1 s2 = s1 ^ "\n" ^ s2

let xml2string config xml =
  let () = ConfigState.set_all config in
  let rec sub btag xml =
    match xml with
    | Element(tag, attrib_lst, children) ->
      let attib_str_lst =
        List.map (ConfigApply.set_attrib tag) attrib_lst
        |> show_option
        |> List.sort (fun (_, n1) (_, n2) -> ord_int n1 n2)
      in
      let attrib =
        let f (str, n) = add_paren str in
        List.fold_right join_str (List.map f attib_str_lst) ""
      in
      let tag_name = ConfigApply.to_cmd btag tag in
      let children_str =
        List.fold_right join_str (List.map (sub tag) children) ""
      in
        "\n" ^ tag_name
          ^ attrib ^ "\n"
          ^ ConfigApply.type_paren tag children_str
          ^ ConfigApply.type_semicolon btag
(*
      let join s1 s2 = s1 ^ "\n" ^ s2 in
      let f1 lst =
        let f (attrib, var) =
          add_paren var
        in
        List.map f lst |> List.fold_left join ""
      in
      let f2 lst =
        List.map (sub tag) lst |> List.fold_left join ""
      in
        ConfigApply.tag tag (f1 opt_lst) (add_paren (f2 children))
*)
    | PCData(str) -> ConfigApply.pcdata btag str
  in
  match xml with
    | Element(tag, attrib_lst, children) ->
        let attib_str_lst =
          List.map (ConfigApply.set_attrib tag) attrib_lst
          |> show_option
          |> List.sort (fun (_, n1) (_, n2) -> ord_int n1 n2)
        in
        let attrib =
          let f (str, n) = add_paren str in
          List.fold_right join_str (List.map f attib_str_lst) ""
        in
        let fun_name = String.uncapitalize_ascii tag in
        let children_str =
          List.fold_right join_str (List.map (sub tag) children) ""
        in
          "\n" ^ fun_name
            ^ attrib ^ "\n"
            ^ ConfigApply.type_paren tag children_str
    | PCData(str) -> SatysfiSyntax.from_string str


let main_of_xml (output_file_name: string) (config_file_name: string) (input_xml: Xml.xml) =
  let config = open_in config_file_name |> Lexing.from_channel |> Parse.parse Lex.lex in
  let body = xml2string config input_xml in
  let header =
    ConfigApply.requirePackage () ^ "\n" ^  ConfigApply.importPackage ()
  in
  let main = header ^ "\n" ^ body in
  let open_channel = open_out output_file_name in
  let () = Printf.fprintf open_channel "%s" main in
  let () = close_out open_channel in
    ()


let arg_version () =
  print_string "xml2saty version 0.0.1\n"


let arg_input_file curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_input_file path


let arg_input_text s =
  OptionState.set_input_text s


let arg_output curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_output_file path


let arg_config curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_config_file path


let arg_spec curdir =
  [
    ("-v",        Arg.Unit(arg_version)  , "Prints version");
    ("--version", Arg.Unit(arg_version)  , "Prints version");
    ("-f",     Arg.String (arg_input_file curdir), "Specify XML file");
    ("--file", Arg.String (arg_input_file curdir), "Specify XMML file");
    ("-t",     Arg.String arg_input_text, "Give XML text");
    ("--text", Arg.String arg_input_text, "Give XML text");
    ("-o",       Arg.String (arg_output curdir),  "Specify output file");
    ("--output", Arg.String (arg_output curdir), "Specify output file");
    ("-c",      Arg.String (arg_config curdir), "Specify config file");
    ("--config",Arg.String (arg_config curdir), "Specify config file");
  ]


let main =
  let curdir = Sys.getcwd () in
  Arg.parse (arg_spec curdir) (arg_input_file curdir) "";
    if OptionState.is_do_not_parse () then
      ()
    else
      if OptionState.is_file_mode () then
        let make_output_file =
          let file = Filename.chop_extension (OptionState.input_file () |> option_from "") in
            file ^ ".saty"
        in
        let make_config_file =
          let file = Filename.chop_extension (OptionState.input_file () |> option_from "") in
            file ^ ".x2s-config"
        in
        let output_file_name = OptionState.output_file () |> option_from make_output_file in
        let config_file_name = OptionState.config_file () |> option_from make_config_file in
        let input_xml = OptionState.input_file () |> option_from "" |> Xml.parse_file in
        main_of_xml output_file_name config_file_name input_xml
      else
        let output_file_name = OptionState.output_file () |> option_from "" in
        let config_file_name = OptionState.config_file () |> option_from "" in
        let input_xml = OptionState.input_text () |> option_from "" |> Xml.parse_string in
        main_of_xml output_file_name config_file_name input_xml