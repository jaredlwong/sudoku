open List

let explode s = List.init (String.length s) (String.get s)

let range start end_ =
  let rec range_ acc i =
    if i = end_ then acc
    else range_ (i :: acc) (i + 1)
  in
  List.rev (range_ [] start)

let string_to_puzzle input =
  let nums = List.map (fun c ->
    if c = '.' then 0
    else int_of_string (String.make 1 c)
  ) (explode input) in
  List.map (fun i ->
    List.map (fun j ->
      List.nth nums (i*9+j)) (range 0 9)) (range 0 9)

let is_valid_row (row: int list) : bool =
  let checkset = Array.make 10 0 in
  List.iter (fun e -> checkset.(e) <- checkset.(e) + 1) row;
  List.for_all (fun e -> e <= 1) (Array.to_list (Array.sub checkset 1 9))


let lookup (grid: int list list) (row: int) (col: int) : int =
  List.nth (List.nth grid row) col

let check_boxes grid =
  let indices =
    map (fun x ->
      List.combine (range ((x / 3) * 3) ((x / 3) * 3 + 3)) (range ((x mod 3) * 3) ((x mod 3) * 3 + 3))
    ) (range 0 9)
  in
  let boxes =
    map (fun index ->
      List.map (fun (r, c) -> lookup grid r c) index
    ) indices
  in
  List.for_all is_valid_row boxes


let is_valid (grid: int list list) : bool =
  (* check rows *)
  if List.exists (fun r -> not (is_valid_row (List.nth grid r))) (range 0 9) then
    false
  else
    (* check cols *)
    let transposed = List.map (fun col -> List.map (fun row -> List.nth row col) grid) (range 0 9) in
    if List.exists (fun c -> not (is_valid_row (List.nth transposed c))) (range 0 9) then
      false
    else
      (* check boxes *)
      check_boxes grid

let cartesian l l' = 
  List.concat (List.map (fun e -> List.map (fun e' -> (e,e')) l') l)

let next_open (grid: int list list) =
  let indices = cartesian (range 0 9) (range 0 9) in
  let opened = List.filter (fun (x, y) -> (lookup grid x y) = 0) indices in
  match opened with
  | hd :: _ -> Some hd
  | _ -> None

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