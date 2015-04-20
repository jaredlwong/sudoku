#include <vector>
#include <iostream>
#include <cstring>

class Sudoku {
private:
	std::vector<std::vector<int>> rep;
	// doesn't copy first row???
	//std::vector<std::vector<int>>& rep;
public:
	Sudoku(std::vector<std::vector<int>>&& sudoku);
	bool valid();
	bool complete();
	bool solve();
};

Sudoku::Sudoku(std::vector<std::vector<int>>&& sudoku) : rep(sudoku) {}

bool Sudoku::valid() {
	int seen[10] = {};
	for (int i = 0; i < 9; ++i) {
		memset(seen, 0, sizeof(seen));
		for (int j = 0; j < 9; ++j) {
			int e = this->rep[i][j];
			if (e > 0 && (++seen[e]) > 1) {
				return false;
			}
		}
	}

	for (int i = 0; i < 9; ++i) {
		memset(seen, 0, sizeof(seen));
		for (int j = 0; j < 9; ++j) {
			int e = this->rep[j][i];
			if (e > 0 && (++seen[e]) > 1) {
				return false;
			}
		}
	}

	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			memset(seen, 0, sizeof(seen));
			for (int k = i*3; k < i*3+3; ++k) {
				for (int l = j*3; l < j*3+3; ++l) {
					int e = this->rep[k][l];
					if (e > 0 && (++seen[e]) > 1) {
						return false;
					}
				}
			}
		}
	}

	return true;
}

bool Sudoku::complete() {
	if (!this->valid()) {
		return false;
	}

	for (std::vector<int> row : this->rep) {
		for (int e : row) {
			if (e == 0) {
				return false;
			}
		}
	}

	return true;
}

bool Sudoku::solve() {
	
}

int main() {
	Sudoku s = Sudoku({
		{8,0,1,3,4,0,0,0,0},
		{4,3,0,8,0,0,1,0,7},
		{0,0,0,0,6,0,0,0,3},
		{2,0,8,0,5,0,0,0,9},
		{0,0,9,0,0,0,7,0,0},
		{6,0,0,0,7,0,8,0,4},
		{3,0,0,0,1,0,0,0,0},
		{1,0,5,0,0,6,0,4,2},
		{0,0,0,0,2,4,3,0,8}});

	std::cout << s.valid() << '\n';
	std::cout << s.complete() << '\n';
	return 0;
}
