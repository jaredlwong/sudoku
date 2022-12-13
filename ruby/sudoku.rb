require 'time'

class Sudoku
    attr_accessor :grid

    def initialize(input)
        @grid = []
        for i in 0...9
            @grid[i] = []
            for j in 0...9
                val = input[i*9+j]
                @grid[i][j] = val.to_i if val != '.'
                @grid[i][j] = 0 if val == '.'
            end
        end
    end

    def to_s
        return @grid.flatten.join
    end

    def is_valid
        # check rows
        for r in 0...9
            checkset = Array.new(10, 0)
            # puts(checkset)
            for c in 0...9
                # puts("#{r}, #{c}, #{@grid[r][c]}")
                # puts('"' + checkset[@grid[r][c]].to_s + '"')
                checkset[@grid[r][c]] += 1
                if @grid[r][c] > 0 && checkset[@grid[r][c]] > 1
                    return false
                end
            end
        end

        # check cols
        for c in 0...9
            checkset = Array.new(10, 0)
            for r in 0...9
                checkset[@grid[r][c]] += 1
                if @grid[r][c] > 0 && checkset[@grid[r][c]] > 1
                    return false
                end
            end
        end

        # check boxes
        for x in 0...9
            checkset = Array.new(10, 0)
            box_row = x / 3
            box_col = x % 3
            for r in box_row * 3...(box_row * 3 + 3)
                for c in box_col * 3...(box_col * 3 + 3)
                    checkset[@grid[r][c]] += 1
                    if @grid[r][c] > 0 && checkset[@grid[r][c]] > 1
                        return false
                    end
                end
            end
        end

        return true
    end

    def next_open
        for r in 0...9
            for c in 0...9
                if @grid[r][c] == 0
                    return [r, c]
                end
            end
        end
        return nil
    end

    def solve
        if not self.is_valid
            return false
        end
        p = self.next_open
        # if complete
        if not p
            return true
        end
        row, col = p
        for v in 1..9
            @grid[row][col] = v
            result = self.solve
            if result
                return true
            end
            @grid[row][col] = 0
        end
        return false
    end
end

if __FILE__ == $0
    if ARGV.empty?
        puts "Please provide the name of an input file as an argument."
        exit 1
    end

    filename = ARGV[0]

    lines = File.readlines(filename).map(&:strip).reject(&:empty?)
    for i in (0...lines.length).step(2)
        input = lines[i]
        expected = lines[i+1]
        s = Sudoku.new(input)
        start = Time.now
        s.solve
        end_time = Time.now
        if s.to_s == expected
            puts "Solved sudoku #{input} in #{(end_time-start)*1000} ms"
        else
            puts "Failed to solve sudoku #{input}. Expected #{expected}, got #{s}"
            exit 1
        end
    end
end