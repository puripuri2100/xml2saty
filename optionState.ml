
type state = {
  mutable input_file : string option;
  mutable input_text : string option;
  mutable output_file : string option;
  mutable config_file : string option;
}


let state = {
  input_file = None;
  input_text = None;
  output_file = None;
  config_file = None;
}

let set_input_file path = state.input_text <- None ; state.input_file <- Some(path)
let input_file () = state.input_file

let set_input_text s = state.input_file <- None ; state.input_text <- Some(s)
let input_text () = state.input_text

let is_file_mode () =
  match state.input_file with
  | Some(_) -> true
  | None -> false

let set_output_file path = state.output_file <- Some(path)
let output_file () = state.output_file


let set_config_file path = state.config_file <- Some(path)
let config_file () = state.config_file


let is_do_not_parse () =
  match (state.input_file, state.input_text) with
  | (None, None) -> true
  | _ -> false