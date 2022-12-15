import Foundation

func stringToPuzzle(input: String) -> [Int] {
    var puzzle: [Int] = []
    for c in input {
        if c != "." {
            puzzle.append(Int(String(c))!)
        } else {
            puzzle.append(0)
        }
    }
    return puzzle
}

func puzzleToString(puzzle: [Int]) -> String {
    var s = [String]()
    for e in puzzle {
        if e != 0 {
            s.append(String(e))
        } else {
            s.append(".")
        }
    }
    return s.joined()
}

func is_valid_row(row: [Int]) -> Bool {
    var checkset: [Int] = [Int](repeating: 0, count: 10)
    for num in row {
        checkset[num] += 1
    }
    for count in checkset[1...] {
        if count > 1 {
            return false
        }
    }
    return true
}

func is_valid(_ grid: [Int]) -> Bool {
    var row: [Int] = [Int](repeating: 0, count: 9)
    for r in 0..<9 {
        for c in 0..<9 {
            row[c] = grid[r*9+c]
        }
        if !is_valid_row(row:row) {
            return false
        }
    }
    var col: [Int] = [Int](repeating: 0, count: 9)
    for c in 0..<9 {
        for r in 0..<9 {
            col[r] = grid[r*9+c]
        }
        if !is_valid_row(row:col) {
            return false
        }
    }
    for i in 0..<9 {
        let box_row = i / 3
        let box_col = i % 3
        var box: [Int] = []
        for r in box_row * 3..<(box_row * 3 + 3) {
            for c in box_col * 3..<(box_col * 3 + 3) {
                box.append(grid[r*9+c])
            }
        }
        if !is_valid_row(row:box) {
            return false
        }
    }
    return true
}

func next_open(grid: [Int]) -> Int? {
    for i in 0..<81 {
        if grid[i] == 0 {
            return i
        }
    }
    return nil
}

func solve(grid: inout [Int]) -> Bool {
    if !is_valid(grid) {
        return false
    }
    let p = next_open(grid: grid)
    if p == nil {
        return true
    }
    for v in 1...9 {
        grid[p!] = v
        if solve(grid: &grid) {
            return true
        }
        grid[p!] = 0
    }
    return false
}

func main() {
    if CommandLine.argc < 2 {
        print("Please provide the name of an input file as an argument.")
        exit(1)
    }

    let filename = CommandLine.arguments[1]

    if let lines = try? String(contentsOfFile: filename)
            .components(separatedBy: "\n")
            .filter({ !$0.isEmpty }) {
        for i in stride(from: 0, to: lines.count, by: 2) {
            let input = lines[i]
            let expected = lines[i+1]
            var s = stringToPuzzle(input:input)
            let start = Date()
            let solved = solve(grid: &s)
            let end = Date()
            if solved && puzzleToString(puzzle:s) == expected {
                print("Solved sudoku \(input) in \(end.timeIntervalSince(start) * 1000) ms")
            } else {
                print("Failed to solve sudoku \(input). Expected \(expected), got \(s)")
                exit(1)
            }
        }
    }
}

main()