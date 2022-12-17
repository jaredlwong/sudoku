#include <vector>
#include <string>
#include <iostream>
#include <fstream>
using namespace std;

vector<vector<int>> convert(string input) {
    vector<vector<int>> grid(9, vector<int>(9, 0));
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            char val = input[i*9+j];
            if (val != '.') {
                grid[i][j] = int(val) - int('0');
            }
        }
    }
    return grid;
}

string puzzle_to_string(vector<vector<int>> grid) {
    string output;
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            output += to_string(grid[i][j]);
        }
    }
    return output;
}

bool is_valid(vector<vector<int>> grid) {
    // check rows
    for (int r = 0; r < 9; r++) {
        vector<int> checkset(10, 0);
        for (int c = 0; c < 9; c++) {
            checkset[grid[r][c]] += 1;
            if (grid[r][c] > 0 && checkset[grid[r][c]] > 1) {
                return false;
            }
        }
    }

    // check cols
    for (int c = 0; c < 9; c++) {
        vector<int> checkset(10, 0);
        for (int r = 0; r < 9; r++) {
            checkset[grid[r][c]] += 1;
            if (grid[r][c] > 0 && checkset[grid[r][c]] > 1) {
                return false;
            }
        }
    }

    // check boxes
    for (int x = 0; x < 9; x++) {
        vector<int> checkset(10, 0);
        int box_row = x / 3;
        int box_col = x % 3;
        for (int r = box_row * 3; r < box_row * 3 + 3; r++) {
            for (int c = box_col * 3; c < box_col * 3 + 3; c++) {
                checkset[grid[r][c]] += 1;
                if (grid[r][c] > 0 && checkset[grid[r][c]] > 1) {
                    return false;
                }
            }
        }
    }
    return true;
}

pair<int, int> next_open(vector<vector<int>> grid) {
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            if (grid[r][c] == 0) {
                return {r, c};
            }
        }
    }
    return {-1, -1};
}

bool solve(vector<vector<int>>& grid) {
    if (!is_valid(grid)) {
        return false;
    }
    pair<int, int> p = next_open(grid);
    // if complete
    if (p.first == -1) {
        return true;
    }
    int row = p.first;
    int col = p.second;
    for (int v = 1; v < 10; v++) {
        grid[row][col] = v;
        bool result = solve(grid);
        if (result) {
            return true;
        }
        grid[row][col] = 0;
    }
    return false;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cout << "Please provide the name of an input file as an argument." << std::endl;
        exit(1);
    }

    std::ifstream f(argv[1]);
    std::string line;
    std::vector<std::string> lines;
    while (std::getline(f, line)) {
        if (line.empty()) {
            continue;
        }
        lines.push_back(line);
    }

    for (int i = 0; i < lines.size(); i += 2) {
        std::string input = lines[i];
        std::string expected = lines[i+1];
        vector<vector<int>> s = convert(input);
        clock_t start = clock();
        solve(s);
        clock_t end = clock();
        int ms = (end - start) / (double) (CLOCKS_PER_SEC / 1000);
        if (puzzle_to_string(s) == expected) {
            std::cout << "Solved sudoku " << input << " in " << ms << " ms" << std::endl;
        } else {
            std::cout << "Failed to solve sudoku " << input << ". Expected " << expected << ", got " << puzzle_to_string(s) << std::endl;
            exit(1);
        }
    }
    return 0;
}