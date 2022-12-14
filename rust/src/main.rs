use std::env;
use std::fs;
use std::fmt;
use std::time::Instant;


macro_rules! get {
    ($array:ident, $i:expr, $j:expr) => {
        $array[$i * 9 + $j] as usize
    }
}

macro_rules! set {
    ($array:ident, $i:expr, $j:expr, $v:expr) => {
        $array[$i * 9 + $j] = $v;
    }
}

macro_rules! index2i {
    ($index:expr) => {
        $index / 9
    }
}

macro_rules! index2j {
    ($index:expr) => {
        $index % 9
    }
}

macro_rules! ij2index {
    ($i:expr, $j:expr) => {
        ($i / 3) * 3 + ($j / 3)
    }
}

fn parse_sudoku(str_rep: &str, sudoku: &mut [u8; 81]) {
    for (i, c) in str_rep.chars().enumerate() {
        if c == '.' {
            sudoku[i] = 0;
        } else {
            sudoku[i] = c.to_digit(10).unwrap() as u8;
        }
    }
}

fn sudoku_to_string(sudoku: &[u8]) -> String {
    sudoku.iter().map(|c| {
        if *c == 0 { '.' } else { std::char::from_digit(*c as u32, 10).unwrap() }
    }).collect()
}

/* return number of constants in array */
fn sudoku_constants(board: &[u8], constants: &mut [u8]) -> usize {
    let mut c = 0;
    for (i, b) in board.iter().enumerate() {
        if *b == 0 {
            constants[c] = i as u8;
            c += 1;
        }
    }
    c
}

fn sudoku_rows(sudoku: &[u8], rows: &mut [u8]) {
    for i in 0..9 {
        for j in 0..9 {
            if get!(sudoku, i, j) > 0 {
                set!(rows, i, get!(sudoku, i, j) - 1, 1);
            }
        }
    }
}

fn sudoku_cols(sudoku: &[u8], cols: &mut [u8]) {
    for i in 0..9 {
        for j in 0..9 {
            if get!(sudoku, j, i) > 0 {
                set!(cols, i, get!(sudoku, j, i) - 1, 1);
            }
        }
    }
}

fn sudoku_sqrs(sudoku: &[u8], sqrs: &mut [u8]) {
    for i in 0..3 {
        for j in 0..3 {
            for k in i*3..i*3+3 {
                for l in j*3..j*3+3 {
                    if get!(sudoku, k, l) > 0 {
                        set!(sqrs, ij2index!(k, l), get!(sudoku, k, l)-1, 1);
                    }
                }
            }
        }
    }
}

fn sudoku_solve(sudoku: &mut [u8; 81]) -> bool {
    let mut constants: [u8; 81] = [0; 81];
    let mut rows: [u8; 81] = [0; 81];
    let mut cols: [u8; 81] = [0; 81];
    let mut sqrs: [u8; 81] = [0; 81];
    let mut cur_const: usize = 0;
    let mut i: usize;
    let mut j: usize;

    let num_consts: usize = sudoku_constants(sudoku, &mut constants);
    sudoku_rows(sudoku, &mut rows);
    sudoku_cols(sudoku, &mut cols);
    sudoku_sqrs(sudoku, &mut sqrs);

    loop {
        if sudoku[constants[num_consts-1] as usize] != 0 {
            return true;
        }
        i = index2i!(constants[cur_const] as usize);
        j = index2j!(constants[cur_const] as usize);
        set!(sudoku, i, j, 1);
        loop {
            if get!(rows, i, get!(sudoku, i, j) as usize-1) != 0 ||
               get!(cols, j, get!(sudoku, i, j) as usize-1) != 0 ||
               get!(sqrs, ij2index!(i,j), get!(sudoku, i, j) as usize-1) != 0 {
                if get!(sudoku, i, j) == 9 {
                    set!(sudoku, i, j, 0);
                    cur_const -= 1;
                    i = index2i!(constants[cur_const] as usize);
                    j = index2j!(constants[cur_const] as usize);
                    loop {
                        if get!(sudoku, i, j) == 9 {
                            set!(rows, i, get!(sudoku, i, j) as usize-1, 0);
                            set!(cols, j, get!(sudoku, i, j) as usize-1, 0);
                            set!(sqrs, ij2index!(i,j), get!(sudoku, i, j) as usize-1, 0);
                            set!(sudoku, i, j, 0);
                            cur_const -= 1;
                            i = index2i!(constants[cur_const] as usize);
                            j = index2j!(constants[cur_const] as usize);
                        } else {
                            break;
                        }
                    }
                    set!(rows, i, get!(sudoku, i, j) as usize-1, 0);
                    set!(cols, j, get!(sudoku, i, j) as usize-1, 0);
                    set!(sqrs, ij2index!(i,j), get!(sudoku, i, j) as usize-1, 0);
                }
                set!(sudoku, i, j, (get!(sudoku, i, j) as u8)+1);
            } else {
                break;
            }
        }
        set!(rows, i, get!(sudoku, i, j) as usize-1, 1);
        set!(cols, j, get!(sudoku, i, j) as usize-1, 1);
        set!(sqrs, ij2index!(i,j), get!(sudoku, i, j) as usize-1, 1);
        cur_const += 1;
    }
}

struct Sudoku {
    grid: [[usize; 9]; 9],
}

impl Sudoku {
    fn new() -> Sudoku {
        Sudoku {
            grid: [[0; 9]; 9],
        }
    }

    fn parse_sudoku(str: &str) -> Sudoku {
        let mut sp: Sudoku = Sudoku::new();
        for i in 0..9 {
            for j in 0..9 {
                let val = &str[i * 9 + j..i * 9 + j + 1];
                sp.grid[i][j] = if val == "." { 0 } else { val.parse().unwrap() };
            }
        }
        sp
    }

    fn is_valid(&self) -> bool {
        // check rows
        for r in 0..9 {
            let mut checkset: usize = 0;
            for c in 0..9 {
                let mask = 1 << self.grid[r][c];
                if self.grid[r][c] > 0 && checkset & mask > 0 {
                    return false;
                }
                checkset |= mask;
            }
        }

        // check cols
        for c in 0..9 {
            let mut checkset: usize = 0;
            for r in 0..9 {
                let mask = 1 << self.grid[r][c];
                if self.grid[r][c] > 0 && checkset & mask > 0 {
                    return false;
                }
                checkset |= mask;
            }
        }

        // check boxes
        for x in 0..9 {
            let mut checkset = [0; 10];
            let box_row = x / 3;
            let box_col = x % 3;
            for r in box_row * 3..box_row * 3 + 3 {
                for c in box_col * 3..box_col * 3 + 3 {
                    checkset[self.grid[r][c]] += 1;
                    if self.grid[r][c] > 0 && checkset[self.grid[r][c]] > 1 {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    fn next_open(&self) -> Option<(usize, usize)> {
        for r in 0..9 {
            for c in 0..9 {
                if self.grid[r][c] == 0 {
                    return Some((r, c));
                }
            }
        }
        return None;
    }

    fn solve(&mut self) -> bool {
        if !self.is_valid() {
            return false;
        }
        match self.next_open() {
            None => true,
            Some((r, c)) => {
                for v in 1..=9 {
                    self.grid[r][c] = v;
                    if self.solve() {
                        return true;
                    }
                    self.grid[r][c] = 0;
                }
                false
            }
        }
    }
}

impl fmt::Display for Sudoku {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let mut s = String::new();
        for row in self.grid.iter() {
            for v in row {
                s.push_str(&v.to_string());
            }
        }
        write!(f, "{}", s)
    }
}



fn main() {
    // Get the first command line argument (the file path)
    let args: Vec<String> = env::args().collect();
    let file_path = &args[1];
    
    // Read the file into a string
    let contents = fs::read_to_string(file_path).expect("Failed to read file");
    let puzzles: Vec<&str> = contents.lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .collect();
    
    for puzzle in puzzles.chunks(2) {
        let input = puzzle[0];
        let expected = puzzle[1];

        let start = Instant::now();
        let mut sudoku: [u8; 81] = [0; 81];
        parse_sudoku(input, &mut sudoku);
        sudoku_solve(&mut sudoku);
        let output = sudoku_to_string(&sudoku);
        let end = Instant::now();
        let millis = (end.duration_since(start).as_nanos() as f64) / 1000000.0;
        if output == expected {
            println!("Solved sudoku {} in {} ms", input, millis);
        } else {
            println!("Failed to solve sudoku {}. Expected {}, got {}", input, expected, output);
        }
        
        // let mut sudoku: Sudoku = Sudoku::parse_sudoku(input);
        // let start = Instant::now();
        // sudoku.solve();
        // let end = Instant::now();
        // let elapsed_time = end.duration_since(start).as_millis();
        // let output = sudoku.to_string();
        // if output == expected {
        //     println!("Solved sudoku {} in {} ms", input, elapsed_time);
        // } else {
        //     println!("Failed to solve sudoku {}. Expected {}, got {}", input, expected, output);
        // }
    }
}
