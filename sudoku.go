package main

import (
	"strings"
	"strconv"
	"fmt"
	"bytes"
)

type Sudoku [9][9]byte

func parseSudoku(str string) Sudoku {
	sp := new(Sudoku)
	s := *sp
	for i, row := range strings.Split(str, "\n") {
		for j, val := range strings.Split(row, " ") {
			v, _ := strconv.Atoi(val)
			s[i][j] = byte(v)
		}
	}
	return s
}

func sudokuToString(s Sudoku) string {
	var buf bytes.Buffer
	for _, row := range s {
		for _, v := range row {
			buf.WriteString(fmt.Sprintf("%d", v))
		}
		buf.WriteString("\n")
	}
	return buf.String()
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
	fmt.Println(sudokuToString(s))
//	fmt.Println("%s\n", )
}
