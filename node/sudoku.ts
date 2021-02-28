interface Sudoku {
  grid: number[][];
}

class Sudoku {
  grid: number[][];

  constructor(grid: number[][]) {
    this.grid = grid;
  }

  is_valid(): boolean {
    // check rows
    for (let r = 0; r < 9; r++) {
      let numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      for (let c = 0; c < 9; c++) {
        numset[this.grid[r][c]] += 1;
        if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
          return false;
        }
      }
    }

    // check cols
    for (let c = 0; c < 9; c++) {
      let numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      for (let r = 0; r < 9; r++) {
        numset[this.grid[r][c]] += 1;
        if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
          return false;
        }
      }
    }

    // check boxes
    for (let b = 0; b < 9; b++) {
      let numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      let box_row = Math.floor(b / 3);
      let box_col = b % 3;
      for (let r = box_row * 3; r < box_row * 3 + 3; r++) {
        for (let c = box_col * 3; c < box_col * 3 + 3; c++) {
          numset[this.grid[r][c]] += 1;
          if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
            return false;
          }
        }
      }
    }

    return true;
  }

  next_open(): [number, number] {
    for (let r = 0; r < 9; r++) {
      for (let c = 0; c < 9; c++) {
        if (this.grid[r][c] == 0) {
          return [r, c];
        }
      }
    }
    return null;
  }

  solve(): boolean {
    if (!this.is_valid()) {
      return false;
    }
    let pos = this.next_open();
    if (pos == null) {
      return true;
    }
    for (let v = 1; v <= 9; v++) {
      this.grid[pos[0]][pos[1]] = v;
      let is_finished = this.solve();
      if (is_finished) {
        return true;
      }
      this.grid[pos[0]][pos[1]] = 0;
    }
    return false;
  }

  public toString = () : string => {
    let s = '';
    for (var row of this.grid) {
      s += row.join(' ') + '\n';
    }
    return s;
  }
}


let s = new Sudoku([
  [8, 0, 1, 3, 4, 0, 0, 0, 0],
  [4, 3, 0, 8, 0, 0, 1, 0, 7],
  [0, 0, 0, 0, 6, 0, 0, 0, 3],
  [2, 0, 8, 0, 5, 0, 0, 0, 9],
  [0, 0, 9, 0, 0, 0, 7, 0, 0],
  [6, 0, 0, 0, 7, 0, 8, 0, 4],
  [3, 0, 0, 0, 1, 0, 0, 0, 0],
  [1, 0, 5, 0, 0, 6, 0, 4, 2],
  [0, 0, 0, 0, 2, 4, 3, 0, 8],
]);

s.solve();

console.log(s.toString());
