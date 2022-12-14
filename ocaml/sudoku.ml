open List
open String

let explode s = List.init (String.length s) (String.get s)

let lookup (grid: int list list) (row: int) (col: int) : int =
  List.nth (List.nth grid row) col

let cartesian l l' = 
  List.concat (List.map (fun e -> List.map (fun e' -> (e,e')) l') l)

let range start end_ =
  let rec range_ acc i =
    if i = end_ then acc
    else range_ (i :: acc) (i + 1)
  in
  List.rev (range_ [] start)

let string_to_puzzle (input: string) : int array =
  Array.init (String.length input) (fun i ->
    let c = String.get input i in
    if c != '.' then int_of_char c else 0
  )

let puzzle_to_string (puzzle: int array) : string =
  let string_list = Array.map (fun e -> if e != 0 then string_of_int e else ".") puzzle in
  Array.fold_left (fun acc s -> acc ^ s) "" string_list

let is_valid_row (row: int list) : bool =
  let checkset = Array.make 10 0 in
  List.iter (fun e -> checkset.(e) <- checkset.(e) + 1) row;
  Array.for_all (fun e -> e <= 1) (Array.sub checkset 1 9)

let is_valid grid =
  let rows = List.init 9 (fun r -> List.init 9 (fun c -> grid.(r * 9 + c))) in
  let cols = List.init 9 (fun c -> List.init 9 (fun r -> grid.(r * 9 + c))) in
  let boxs = List.init 9 (fun i ->
    let row = (i / 3) * 3 in
    let col = (i mod 3) * 3 in
    List.flatten (List.init 3 (fun r -> List.init 3 (fun c -> grid.((row+r)*9+(col+c)))))
  ) in
  List.for_all is_valid_row rows && List.for_all is_valid_row cols && List.for_all is_valid_row boxs

let next_open grid =
  let yyy = Array.to_list (Array.mapi (fun i x -> (i, x = 0)) grid) in
  let zzz = List.filter (fun (i, x) -> x) yyy in
  zzz.hd

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