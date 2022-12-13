(* Convert the input puzzle to a 2d vector *)
let convert (input : string) : int array array =
  let grid : int array array = Array.make_matrix 9 9 0 in
  let n = String.length input in
  for i = 0 to n - 1 do
    let row = i / 9 in
    let col = i mod 9 in
    let value = input.[i] in
    if value <> '.' then
      let int_val = int_of_string (String.make 1 value) in
      grid.(row).(col) <- int_val
  done;
  grid

let is_valid (grid : int array array) : bool =
  (* Check rows. *)
  let rows_ok =
    for r = 0 to 8 do
      let checkset : int array = Array.make 10 0 in
      for c = 0 to 8 do
        checkset.(grid.(r).(c)) <- checkset.(grid.(r).(c)) + 1;
        if grid.(r).(c) > 0 && checkset.(grid.(r).(c)) > 1 then
          false
        else
          true
      done;
    done;
    true;

  (* Check cols. *)
  for c = 0 to 8 do
    let checkset : int array = Array.make 10 0 in
    for r = 0 to 8 do
      checkset.(grid.(r).(c)) <- checkset.(grid.(r).(c)) + 1;
      if grid.(r).(c) > 0 && checkset.(grid.(r).(c)) > 1 then
        false
    done;
  done;

  (* Check boxes. *)
  for x = 0 to 8 do
    let checkset : int array = Array.make 10 0 in
    let box_row = x / 3 in
    let box_col = x mod 3 in
    for r = box_row * 3 to box_row * 3 + 2 do
      for c = box_col * 3 to box_col * 3 + 2 do
        checkset.(grid.(r).(c)) <- checkset.(grid.(r).(c)) + 1;
        if grid.(r).(c) > 0 && checkset.(grid.(r).(c)) > 1 then
          false
      done;
    done;
  done;

  (* Return true if no duplicates were found. *)
  true

(* Print every two lines together *)
let rec print_pairs = function
  | [] -> ()
  | [x] -> print_endline x
  | x :: y :: tl ->
    Printf.printf "%s %s\n" x y;
    print_pairs tl

(* read_file : string -> string list *)
let read_file filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true do
      lines := input_line chan :: !lines
    done; []
  with End_of_file ->
    close_in chan;
    List.rev !lines

let () =
  if Array.length Sys.argv < 2 then
    print_endline "Please provide a filename as an argument"
  else
    let lines = read_file Sys.argv.(1) in
    (* List.iter (fun line -> print_endline line) lines *)
    print_pairs lines