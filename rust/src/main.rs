use std::env;
use std::fs;
use std::fmt;
use std::time::Instant;


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
        let mut sudoku: Sudoku = Sudoku::parse_sudoku(input);
        let start = Instant::now();
        sudoku.solve();
        let end = Instant::now();
        let elapsed_time = end.duration_since(start).as_millis();
        let output = sudoku.to_string();
        if output == expected {
            println!("Solved sudoku {} in {} ms", input, elapsed_time);
        } else {
            println!("Failed to solve sudoku {}. Expected {}, got {}", input, expected, output);
        }
    }
}
