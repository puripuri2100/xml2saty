open Xml
open Arg
open String
open Printf
open Filename
open Lexing

open Range
open Types
open Parse
open Lex
open JsonConfig
open Error
open OptionState
open SatysfiSyntax
open ConfigState
open ConfigApply


let option_from x opt =
  match opt with
  | Some(a) -> a
  | None -> x

let option_from_opt x opt =
  match opt with
  | Some(a) -> Some(a)
  | None -> Some(x)


let add_paren str = "(" ^ str ^ ")"


let fold_lefti f init lst =
  let rec sub i f init lst =
    match lst with
    | [] -> init
    | x :: xs -> sub (i + 1) f (f i init x) xs
  in
  sub 0 f init lst



let rec make_tab n =
  if n <= 0 then
    ""
  else
    "  " ^ (make_tab (n - 1))


let join_str i s1 s2 =
  if i == 0 then
    s2
  else
    s1 ^ "\n" ^ s2


let make_attrib tag attrib_lst =
  let attib_str_lst =
    ConfigApply.set_attrib tag attrib_lst
  in
  let attrib =
    let f str = add_paren str in
    fold_lefti join_str "" (List.map f attib_str_lst)
  in
    attrib


let xml2string config xml =
  let () = ConfigState.set_all config in
  let rec sub n btag xml =
    match xml with
    | Element(tag, attrib_lst, children) ->
      let () = Printf.printf "start %s\n" tag in
      let tag_name = ConfigApply.to_cmd btag tag in
      let attrib = make_attrib tag attrib_lst in
      let children_str =
        if ConfigApply.is_list tag then
          SatysfiSyntax.to_satysfi_list (List.map (fun s -> s |> sub (n+1) tag |> ConfigApply.type_paren_list tag) children)
        else
          fold_lefti join_str "" (List.map (sub (n+1) tag) children)
      in
      let main_str =
        tag_name
        ^ attrib
        ^ ConfigApply.type_paren tag children_str
        ^ ConfigApply.type_semicolon btag
      in
      let () = Printf.printf "end %s\n" tag in
        main_str
    | PCData(str) -> ConfigApply.pcdata btag str
  in
  match xml with
    | Element(tag, attrib_lst, children) ->
        let attrib = make_attrib tag attrib_lst in
        let eq_new ((_,name),_,_,_,_) = (tag = name) in
        let attrib_lst = ConfigState.get_attrib () in
        let new_tag_name_opt =
          try
            List.find eq_new attrib_lst
            |> (fun (_, opt, _, _, _) -> opt)
          with _ -> None
        in
        let new_tag_name =
          match new_tag_name_opt with
          | Some((_,s)) -> s
          | None -> tag
        in
        let fun_name = String.uncapitalize_ascii new_tag_name in
        let children_str =
          if ConfigApply.is_list tag then
            SatysfiSyntax.to_satysfi_list (List.map (fun s -> s |> sub 0 tag |> ConfigApply.type_paren_list tag) children)
          else
          fold_lefti join_str "" (List.map (sub 0 tag) children)
        in
          fun_name
            ^ attrib
            ^ ConfigApply.type_paren tag children_str
            ^ "\n"
    | PCData(str) -> str


let main_of_xml (output_file_name: string) (config_file_name: string option) (config_file_name_json: string option) (input_xml: Xml.xml) =
  let config =
    match (config_file_name, config_file_name_json) with
    | (Some(f),_) -> open_in f |> Lexing.from_channel |> Parse.parse Lex.lex
    | (_,Some(j)) -> JsonConfig.read_json_file j
    | (_,_) -> open_in "" |> Lexing.from_channel |> Parse.parse Lex.lex
  in
  let is_package = OptionState.is_package () in
  let body_str = xml2string config input_xml in
  let body =
    if not is_package then
      body_str
    else
      let module_name = OptionState.module_name () in
      let fun_name = OptionState.fun_name () in
      "module " ^ module_name ^ " = struct" ^ "\n" ^
      "let " ^ fun_name ^ " = " ^ "\n" ^
      body_str ^ "\n" ^
      "end"
  in
  let header =
    ConfigApply.requirePackage () ^ "\n" ^  ConfigApply.importPackage ()
  in
  let main = header ^ "\n" ^ body in
  let open_channel = open_out output_file_name in
  let () = Printf.fprintf open_channel "%s" main in
  let () = close_out open_channel in
    ()


let arg_version () =
  print_string "xml2saty version 3.0.0\n"


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


let arg_config_json curdir j =
  let path =
    if Filename.is_relative j then
      Filename.concat curdir j
    else
      j
  in
  OptionState.set_config_file_json path


let arg_package str =
  let slst = String.split_on_char ',' str in
  let v =
    match slst with
    | module_name :: fun_name :: [] -> (module_name, fun_name)
    | _ -> raise (Error.Option_error "Enter as \"<module_name>, <function_name>\"")
  in
  OptionState.set_package v


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
    ("-c",      Arg.String (arg_config_json curdir), "Specify config file");
    ("--config",Arg.String (arg_config_json curdir), "Specify config file");
    ("-x",      Arg.String (arg_config curdir), "Specify config file(json)");
    ("--x2s-config",  Arg.String (arg_config curdir), "Specify config file(json)");
    ("-p",       Arg.String (arg_package), "Output as package file");
    ("--package",Arg.String (arg_package), "Output as package file");
  ]


let main =
  Error.error_msg (fun () ->
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
          let output_file_name = OptionState.output_file () |> option_from make_output_file in
          let config_file_name = OptionState.config_file () in
          let config_file_json_name = OptionState.config_file_json () in
          let input_xml = OptionState.input_file () |> option_from "" |> Xml.parse_file in
          main_of_xml output_file_name config_file_name config_file_json_name input_xml
        else
          let output_file_name = OptionState.output_file () |> option_from "" in
          let config_file_name = OptionState.config_file () in
          let config_file_json_name = OptionState.config_file_json () in
          let input_xml = OptionState.input_text () |> option_from "" |> Xml.parse_string in
          main_of_xml output_file_name config_file_name config_file_json_name input_xml
  )
