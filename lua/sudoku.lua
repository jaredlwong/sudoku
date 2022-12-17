function string_to_puzzle(input)
    puzzle = {}
    for i = 1, #input do
        if input:sub(i, i) ~= '.' then
            table.insert(puzzle, tonumber(input:sub(i, i)))
        else
            table.insert(puzzle, 0)
        end
    end
    return puzzle
end

function puzzle_to_string(puzzle)
    local s = {}
    for e in puzzle do
        if e ~= 0 then
            table.insert(s, tostring(e))
        else
            table.insert(s, '.')
        end
    end
    return table.concat(s, '')
end

function is_valid_row(row)
    local checkset = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    for _, e in ipairs(row) do
        if e >= 1
            checkset[e] = checkset[e] + 1
        end
    end
    for _, e in ipairs(checkset) do
        if e > 1 then
            return false
        end
    end
    return true
end

function is_valid(grid)
    for r = 0, 8 do
        row = {0, 0, 0, 0, 0, 0, 0, 0, 0}
        for c = 0, 8 do
            row[c+1] = grid[r*9+c+1]
        end
        if not is_valid_row(row) then
            return false
        end
    end
    for c = 0, 8 do
        col = {0, 0, 0, 0, 0, 0, 0, 0, 0}
        for r = 0, 8 do
            col[r+1] = grid[r*9+c+1]
        end
        if not is_valid_row(col) then
            return false
        end
    end
    for i = 0, 8 do
        box_row = math.floor(i / 3)
        box_col = i % 3
        box = {0, 0, 0, 0, 0, 0, 0, 0, 0}
        k = 1
        for r = box_row*3, box_row*3+2 do
            for c = box_col*3, box_col*3+2 do
                box[k+1] = grid[r*9+c+1]
                k = k + 1
            end
        end
        if not is_valid_row(box) then
            return false
        end
    end
    return true
end

function next_open(grid)
    for i = 1, 81 do
        if grid[i] == 0 then
            return i
        end
    end
    return -1
end

function solve(grid)
    if not is_valid(grid) then
        return false
    end
    local p = next_open(grid)
    if p < 0 then
        return true
    end
    for v = 1, 9 do
        grid[p] = v
        if solve(grid) then
            return true
        end
        grid[p] = 0
    end
    return false
end

function read_filename()
    if #arg < 1 then
        print("Please provide the name of an input file as an argument.")
        os.exit(1)
    end
    return arg[1]
end

function read_file(filename)
    lines = {}
    for line in io.lines(filename) do
        cleaned = line:strip()
        if cleaned ~= '' then
            table.insert(lines, cleaned)
        end
    end
    return lines
end

function solve(lines)
    for i = 1, #lines, 2 do
        input = lines[i]
        expected = lines[i+1]
        s = string_to_puzzle(input)
        start = time.time()
        solve(s)
        end = time.time()
        if puzzle_to_string(s) == expected then
            print("Solved sudoku %s in %d ms" % (input, (end-start)*1000))
        else
            print("Failed to solve sudoku %s. Expected %s, got %s" % (input, expected, s))
            exit(1)
        end
    end
end