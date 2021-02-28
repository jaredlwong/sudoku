var Sudoku = /** @class */ (function () {
    function Sudoku(grid) {
        var _this = this;
        this.toString = function () {
            var s = '';
            for (var _i = 0, _a = _this.grid; _i < _a.length; _i++) {
                var row = _a[_i];
                s += row.join(' ') + '\n';
            }
            return s;
        };
        this.grid = grid;
    }
    Sudoku.prototype.is_valid = function () {
        // check rows
        for (var r = 0; r < 9; r++) {
            var numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            for (var c = 0; c < 9; c++) {
                numset[this.grid[r][c]] += 1;
                if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
                    return false;
                }
            }
        }
        // check cols
        for (var c = 0; c < 9; c++) {
            var numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            for (var r = 0; r < 9; r++) {
                numset[this.grid[r][c]] += 1;
                if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
                    return false;
                }
            }
        }
        // check boxes
        for (var b = 0; b < 9; b++) {
            var numset = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            var box_row = Math.floor(b / 3);
            var box_col = b % 3;
            for (var r = box_row * 3; r < box_row * 3 + 3; r++) {
                for (var c = box_col * 3; c < box_col * 3 + 3; c++) {
                    numset[this.grid[r][c]] += 1;
                    if (this.grid[r][c] > 0 && numset[this.grid[r][c]] > 1) {
                        return false;
                    }
                }
            }
        }
        return true;
    };
    Sudoku.prototype.next_open = function () {
        for (var r = 0; r < 9; r++) {
            for (var c = 0; c < 9; c++) {
                if (this.grid[r][c] == 0) {
                    return [r, c];
                }
            }
        }
        return null;
    };
    Sudoku.prototype.solve = function () {
        if (!this.is_valid()) {
            return false;
        }
        var pos = this.next_open();
        if (pos == null) {
            return true;
        }
        for (var v = 1; v <= 9; v++) {
            this.grid[pos[0]][pos[1]] = v;
            var is_finished = this.solve();
            if (is_finished) {
                return true;
            }
            this.grid[pos[0]][pos[1]] = 0;
        }
        return false;
    };
    return Sudoku;
}());
var s = new Sudoku([
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
