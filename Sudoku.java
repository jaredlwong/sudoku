import java.util.LinkedList;
import java.lang.StringBuilder;

class Pair<T1, T2> {
	private T1 o1;
	private T2 o2;

	public Pair(T1 o1, T2 o2) {
		this.o1 = o1;
		this.o2 = o2;
	}

	public T1 car() {
		return o1;
	}

	public T2 cdr() {
		return o2;
	}

	public String toString() {
		return "(" + o1.toString() + " . " + o2.toString() + ")";
	}
}

public class Sudoku {
	private int[][] board = new int[9][9];

	public Sudoku(int[][] board) {
		for (int i = 0; i < 9; i++) {
			System.arraycopy(board[i], 0, this.board[i], 0, 9);
		}
	}

	public Sudoku clone() {
		return new Sudoku(this.board);
	}

	private boolean isPossible() {
		for (int i = 0; i < 9; i++) {
			int[] seen = new int[10];
			for (int j = 0; j < 9; j++) {
				int v = ++seen[board[j][i]];
				if (board[j][i] > 0 && v > 1) {
					return false;
				}
			}
		}

		for (int i = 0; i < 9; i++) {
			int[] seen = new int[10];
			for (int j = 0; j < 9; j++) {
				int v = ++seen[board[j][i]];
				if (board[j][i] > 0 && v > 1) {
					return false;
				}
			}
		}

		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				int[] seen = new int[10];
				for (int k = i*3; k < i*3+3; k++) {
					for (int l = j*3; l < j*3+3; l++) {
						int v = ++seen[board[k][l]];
						if (board[k][l] > 0 && v > 1) {
							return false;
						}
					}
				}
			}
		}

		return true;
	}

	private boolean isComplete() {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (board[i][j] == 0) {
					return false;
				}
			}
		}
		return true;
	}

	private Pair<Integer, Integer> nextEmptySquare() {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (board[i][j] == 0) {
					return new Pair<Integer, Integer>(i, j);
				}
			}
		}
		return null;
	}

	private LinkedList<Sudoku> genNextSudokus() {
		LinkedList<Sudoku> nextSudokus = new LinkedList<Sudoku>();
		Pair<Integer, Integer> nextEmpty = nextEmptySquare();
		for (int i = 1; i <= 9; i++) {
			Sudoku s = new Sudoku(this.board);
			s.board[nextEmpty.car()][nextEmpty.cdr()] = i;
			nextSudokus.push(s);
		}
		return nextSudokus;
	}

	public Sudoku computeSolution() {
		if (!this.isPossible()) {
			return null;
		}
		if (this.isComplete()) {
			return this;
		}
		LinkedList<Sudoku> nextSudokus = this.genNextSudokus();
		for (Sudoku s : nextSudokus) {
			Sudoku n = s.computeSolution();
			if (n != null) {
				return n;
			}
		}
		return null;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				sb.append(board[i][j]);
			}
			sb.append("\n");
		}
		return sb.toString();
	}

	public static void main(String[] args) {
		int[][] sudoku = {
			{8, 0, 1, 3, 4, 0, 0, 0, 0},
			{4, 3, 0, 8, 0, 0, 1, 0, 7},
			{0, 0, 0, 0, 6, 0, 0, 0, 3},
			{2, 0, 8, 0, 5, 0, 0, 0, 9},
			{0, 0, 9, 0, 0, 0, 7, 0, 0},
			{6, 0, 0, 0, 7, 0, 8, 0, 4},
			{3, 0, 0, 0, 1, 0, 0, 0, 0},
			{1, 0, 5, 0, 0, 6, 0, 4, 2},
			{0, 0, 0, 0, 2, 4, 3, 0, 8}
		};
		Sudoku s = new Sudoku(sudoku);
		Sudoku soln = s.computeSolution();
		System.out.println(soln);
	}
}
