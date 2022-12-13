package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"
)

type Position struct {
	row int
	col int
}

func (s Sudoku) String() string {
	var buf bytes.Buffer
	for _, row := range s.grid {
		for _, v := range row {
			buf.WriteString(fmt.Sprintf("%d", v))
		}
	}
	return buf.String()
}

type Sudoku struct {
	grid [9][9]int
}

func parseSudoku(str string) Sudoku {
	sp := new(Sudoku)
	s := *sp
	for i := 0; i < 9; i++ {
		for j := 0; j < 9; j++ {
			val := string(str[i*9+j])
			v, _ := strconv.Atoi(val)
			s.grid[i][j] = v
		}
	}
	return s
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
		for r := box_row * 3; r < box_row*3+3; r++ {
			for c := box_col * 3; c < box_col*3+3; c++ {
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
	if len(os.Args) < 2 {
		fmt.Println("Please provide the name of an input file as an argument.")
		return
	}

	filename := os.Args[1]

	data, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Printf("Failed to read file %s: %s\n", filename, err)
		return
	}

	input := string(data)
	lines := strings.Split(input, "\n")
	// trim each line in lines and remove empty lines
	for i := 0; i < len(lines); i++ {
		lines[i] = strings.TrimSpace(lines[i])
		if lines[i] == "" {
			lines = append(lines[:i], lines[i+1:]...)
			i--
		}
	}

	for i := 0; i < len(lines); i += 2 {
		input := lines[i]
		expected := lines[i+1]
		s := parseSudoku(input)
		start := time.Now()
		s.Solve()
		end := time.Now()
		if s.String() != expected {
			fmt.Printf("Failed to solve sudoku %s. Expected %s, got %s\n", input, expected, s)
			return
		} else {
			fmt.Printf("Solved sudoku %s in %d ms\n", input, end.Sub(start)/1000000)
		}
	}
}
