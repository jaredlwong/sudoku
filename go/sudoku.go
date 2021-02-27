package main

import (
	"strings"
	"strconv"
	"fmt"
	"bytes"
)

type Sudoku struct {
	grid [9][9]int
}

type Position struct {
	row int
	col int
}

func parseSudoku(str string) Sudoku {
	sp := new(Sudoku)
	s := *sp
	for i, row := range strings.Split(str, "\n") {
		for j, val := range strings.Split(row, " ") {
			v, _ := strconv.Atoi(val)
			s.grid[i][j] = v
		}
	}
	return s
}

func (s Sudoku) String() string {
	var buf bytes.Buffer
	for _, row := range s.grid {
		for _, v := range row {
			buf.WriteString(fmt.Sprintf("%d", v))
		}
		buf.WriteString("\n")
	}
	return buf.String()
}

func (s Sudoku) IsValid() bool {
	// check rows
	for r := 0; r < 9; r++ {
		var checkset [10]int
		for c := 0; c < 9; c++ {
			checkset[s.grid[r][c]] += 1
			if s.grid[r][c] > 0 && checkset[s.grid[r][c]] > 1 {
				return false
			}
		}
	}

	// check cols
	for c := 0; c < 9; c++ {
		var checkset [10]int
		for r := 0; r < 9; r++ {
			checkset[s.grid[r][c]] += 1
			if s.grid[r][c] > 0 && checkset[s.grid[r][c]] > 1 {
				return false
			}
		}
	}

	// check boxes
	for x := 0; x < 9; x++ {
		var checkset [10]int
		box_row := x / 3
		box_col := x % 3
		for r := box_row * 3; r < box_row * 3 + 3; r++ {
			for c := box_col * 3; c < box_col * 3 + 3; c++ {
				checkset[s.grid[r][c]] += 1
				if s.grid[r][c] > 0 && checkset[s.grid[r][c]] > 1 {
					return false
				}
			}
		}
	}

	return true
}

func (s Sudoku) NextOpen() *Position {
	for r := 0; r < 9; r++ {
		for c := 0; c < 9; c++ {
			if s.grid[r][c] == 0 {
				return &Position{row: r, col: c}
			}
		}
	}
	return nil
}

func (s *Sudoku) Solve() bool {
	if !s.IsValid() {
		return false
	}
	p := s.NextOpen()
	// if complete
	if p == nil {
		return true
	}
	for v := 1; v <= 9; v++ {
		s.grid[p.row][p.col] = v
		result := s.Solve()
		if result {
			return true
		}
		s.grid[p.row][p.col] = 0
	}
	return false
}


func main() {
	sudoku := `8 0 1 3 4 0 0 0 0
4 3 0 8 0 0 1 0 7
0 0 0 0 6 0 0 0 3
2 0 8 0 5 0 0 0 9
0 0 9 0 0 0 7 0 0
6 0 0 0 7 0 8 0 4
3 0 0 0 1 0 0 0 0
1 0 5 0 0 6 0 4 2
0 0 0 0 2 4 3 0 8`
	s := parseSudoku(sudoku)
	fmt.Println(s)
	s.Solve()
	fmt.Println(s)
}
