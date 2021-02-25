use std::convert::TryInto;
use std::fmt;

struct Sudoku {
    grid: [[u8; 9]; 9],
}

impl Sudoku {
    fn parse_str(sudoku_raw: &str) -> Box<Sudoku> {
        let sudoku_str: String = sudoku_raw.to_string();
        let mut grid: Vec<[u8; 9]> = Vec::new();
        for row in sudoku_str.split('\n') {
            let row_converted: Vec<u8> = row.split(' ').map(|str| str.parse::<u8>().unwrap()).collect();
            // convert vector into fixed sized array
            let row_array: [u8; 9] = row_converted.try_into().unwrap();
            grid.push(row_array);
        }
        Box::new(Sudoku {
            // convert vector into fixed sized array
            grid: grid.try_into().unwrap(),
        })
    }

    // note how self is passed in by value so that it can be passed by value to RowIterator
    fn rows(&self) -> RowIterator {
        RowIterator {
            sudoku: self,
            index: 0,
        }
    }

    fn cols(&self) -> ColIterator {
        ColIterator {
            sudoku: self,
            index: 0,
        }
    }

    fn boxes(&self) -> BoxIterator {
        BoxIterator {
            sudoku: self,
            index: 0,
        }
    }

    fn copy_and_set(&self, row: usize, col: usize, val: u8) -> Box<Sudoku> {
        let mut new_grid: [[u8; 9]; 9] = self.grid;
        new_grid[row][col] = val;
        Box::new(Sudoku {
            grid: new_grid,
        })
    }

    fn is_valid_group(cells: [u8; 9]) -> bool {
        let mut check_set: [i32; 10] = [0; 10];
        for i in 0..9 {
            let c = cells[i] as usize;
            if c != 0 && check_set[c] == 1 {
                return false
            }
            check_set[c] = 1
        }
        return true
    }

    fn is_valid(&self) -> bool {
        if !self.rows().all(|row| Sudoku::is_valid_group(row)) {
            return false
        }
        if !self.cols().all(|col| Sudoku::is_valid_group(col)) {
            return false
        }
        if !self.boxes().all(|b| Sudoku::is_valid_group(b)) {
            return false
        }
        return true
    }

    fn next_open(&self) -> Option<(usize, usize)> {
        for r in 0..9 {
            for c in 0..9 {
                if self.grid[r][c] == 0 {
                    return Some((r, c))
                }
            }
        }
        return None
    }

    fn is_complete(&self) -> bool {
        return self.next_open().is_none()
    }

    fn generate_next(&self) -> Vec<Box<Sudoku>> {
        let next = self.next_open();
        let mut next_sudokus = Vec::new();
        if let Some((r, c)) = next {
            for v in 1..10 {
                next_sudokus.push(self.copy_and_set(r, c, v));
            }
        }
        return next_sudokus
    }

    fn solve(&self) -> Option<Box<Sudoku>> {
        let mut queue = self.generate_next();
        while queue.len() > 0 {
            let option_sudoku: Option<Box<Sudoku>> = queue.pop();
            if let Some(s) = option_sudoku {
                if !s.is_valid() {
                    continue
                }
                if s.is_complete() {
                    return Some(s)
                }
                queue.append(&mut s.generate_next());
            }
        }
        return None
    }

}


impl fmt::Debug for Sudoku {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Sudoku")
         .field("grid", &self.grid)
         .finish()
    }
}

// https://medium.com/@wastedintel/reference-iterators-in-rust-5603a51b5192
// https://doc.rust-lang.org/std/marker/struct.PhantomData.html
// To be able to refer to a sudoku reference rather than copying it we need to use a lifetime
// annotation. This says that RowIterator is valid as long as Sudoku is valid.
pub struct RowIterator<'a> {
    sudoku: &'a Sudoku,
    index: usize,
}

// Specify that the item has the same lifetime as Sudoku. Basically whatever is returned is only as
// valid as Sudoku is valid.
impl Iterator for RowIterator<'_> {
    type Item = [u8; 9];

    fn next(&mut self) -> Option<Self::Item> {
        if self.index >= 9 {
            return None
        }
        let row = self.sudoku.grid[self.index];
        self.index += 1;
        return Some(row)
    }
}

pub struct ColIterator<'a> {
    sudoku: &'a Sudoku,
    index: usize,
}

impl Iterator for ColIterator<'_> {
    type Item = [u8; 9];

    fn next(&mut self) -> Option<Self::Item> {
        if self.index >= 9 {
            return None
        }
        let vec: Vec<u8> = (0..9).map(|i| self.sudoku.grid[i][self.index]).collect();
        let col: [u8; 9] = vec.try_into().unwrap();
        self.index += 1;
        return Some(col)
    }
}

pub struct BoxIterator<'a> {
    sudoku: &'a Sudoku,
    index: usize,
}

impl Iterator for BoxIterator<'_> {
    type Item = [u8; 9];

    fn next(&mut self) -> Option<Self::Item> {
        if self.index >= 9 {
            return None
        }
        let box_row = self.index / 3;
        let box_col = self.index % 3;
        let mut vec: Vec<u8> = Vec::new();
        for r in box_row*3..box_row*3+3 {
            for c in box_col*3..box_col*3+3 {
                vec.push(self.sudoku.grid[r][c])
            }
        }
        let box_cells: [u8; 9] = vec.try_into().unwrap();
        self.index += 1;
        return Some(box_cells)
    }
}



fn main() {
    let sudoku_raw: &'static str = "8 0 1 3 4 0 0 0 0
4 3 0 8 0 0 1 0 7
0 0 0 0 6 0 0 0 3
2 0 8 0 5 0 0 0 9
0 0 9 0 0 0 7 0 0
6 0 0 0 7 0 8 0 4
3 0 0 0 1 0 0 0 0
1 0 5 0 0 6 0 4 2
0 0 0 0 2 4 3 0 8";
    let sudoku: Box<Sudoku> = Sudoku::parse_str(sudoku_raw);
    println!("{}", sudoku.is_valid());
    println!("{:?}", sudoku);
    println!("{:?}", sudoku.solve());
}
