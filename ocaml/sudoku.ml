open List
open String
open Printf

let print_array (row : int array) : unit =
  Array.iter (fun e -> Printf.printf "%d" e) row;
  Printf.printf "\n";
  flush stdout

let print_2d_array (rows : int array array) : unit =
  Array.iter print_array rows

let string_to_puzzle (input: string) : int array =
  Array.init (String.length input) (fun i ->
    let c: string = String.sub input i 1 in
    if c = "." then 0 else int_of_string c
  )

let puzzle_to_string (puzzle: int array) : string =
  let string_list = Array.map (fun e -> if e != 0 then string_of_int e else ".") puzzle in
  Array.fold_left (fun acc s -> acc ^ s) "" string_list

let is_valid_row (row: int array) : bool =
  let checkset = Array.make 10 0 in
  (* Array.iter (fun e -> Printf.printf "%d " e) row; *)
  Array.iter (fun e -> checkset.(e) <- checkset.(e) + 1) row;
  Array.for_all (fun e -> e <= 1) (Array.sub checkset 1 9)

let is_valid (grid: int array) : bool =
  let rows = Array.init 9 (fun r -> Array.init 9 (fun c -> grid.(r * 9 + c))) in
  let cols = Array.init 9 (fun c -> Array.init 9 (fun r -> grid.(r * 9 + c))) in
  let boxs = Array.init 9 (fun i ->
    let row: int = (i / 3) * 3 in
    let col: int = (i mod 3) * 3 in
    let box: int array = Array.make 9 0 in
    for r = 0 to 2 do
      for c = 0 to 2 do
        begin
          box.(r*3+c) <- grid.((row + r) * 9 + (col + c));
        end
      done
    done; box
  ) in
  Array.for_all is_valid_row rows && Array.for_all is_valid_row cols && Array.for_all is_valid_row boxs

let next_open (grid: int array) : int option =
  let rec loop i =
    if i = 81 then
      None
    else if grid.(i) = 0 then
      Some i
    else
      loop (i + 1)
  in loop 0
;;

let rec solve (grid: int array) : bool =
  if not (is_valid grid) then
    begin
      false
    end
  else
    match next_open grid with
     | None -> true
     | Some p ->
        let rec try_value v =
          if v = 10 then
            false
          else
            begin
              grid.(p) <- v;
              if solve grid then
                true
              else
                begin
                  grid.(p) <- 0;
                  try_value (v + 1)
                end
              end
            in
        try_value 1

let read_file (filename: string): string list =
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
    let lines: string list = read_file Sys.argv.(1) in
    for i = 0 to (List.length lines) / 2 - 1 do
      let input: string = List.nth lines (i * 2) in
      let expected: string = List.nth lines (i * 2 + 1) in
      let start_time = Sys.time () in
      let sudoku: int array = string_to_puzzle (input) in
      let result = solve sudoku in
      let output = puzzle_to_string(sudoku) in
      let finish_time = Sys.time () in
      let duration = (finish_time -. start_time) *. 1000.0 in
      if result && expected = output then
        begin
          Printf.printf "Solved sudoku %s in %f ms\n" input duration;
          flush stdout
        end
      else
        begin
          Printf.printf "Failed to solve sudoku %s. Expected %s, got %s\n" input expected output;
          flush stdout
        end
    done