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
				int v = seen[board[j][i]]++;
				if (board[j][i] > 0 && v > 1) {
					return false;
				}
			}
		}

		for (int i = 0; i < 9; i++) {
			int[] seen = new int[10];
			for (int j = 0; j < 9; j++) {
				int v = seen[board[j][i]]++;
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
						int v = seen[board[j][i]]++;
						if (board[j][i] > 0 && v > 1) {
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

	public Sudoku solve() {
		return this;
	}

	public static void main(String[] args) {

	}
}
