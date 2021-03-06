import java.lang.StringBuilder;


public class Sudoku {
  private final int[][] board;

  public Sudoku(int[][] board) {
    this.board = board;
  }

  public static Sudoku fromString(String puzzle) {
    int[][] board = new int[9][9];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        board[r][c] = Character.getNumericValue(puzzle.charAt(r*9+c));
      }
    }
    return new Sudoku(board);
  }

  private boolean isValid() {
    // rows
    for (int r = 0; r < 9; r++) {
      int[] seen = new int[10];
      for (int c = 0; c < 9; c++) {
        if (board[r][c] > 0 && ++seen[board[r][c]] > 1) {
          return false;
        }
      }
    }

    // cols
    for (int c = 0; c < 9; c++) {
      int[] seen = new int[10];
      for (int r = 0; r < 9; r++) {
        if (board[r][c] > 0 && ++seen[board[r][c]] > 1) {
          return false;
        }
      }
    }

    // boxes
    for (int b = 0; b < 9; b++) {
      int[] seen = new int[10];
      int boxRow = b / 3;
      int boxCol = b % 3;
      for (int r = boxRow * 3; r < boxRow * 3 + 3; ++r) {
        for (int c = boxCol * 3; c < boxCol * 3 + 3; ++c) {
          if (board[r][c] > 0 && ++seen[board[r][c]] > 1) {
            return false;
          }
        }
      }
    }

    return true;
  }

  private int nextEmpty() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == 0) {
          return r * 9 + c;
        }
      }
    }
    return -1;
  }

  public boolean solve() {
    if (!this.isValid()) {
      return false;
    }
    int nextEmpty = this.nextEmpty();
    // complete
    if (nextEmpty < 0) {
      return true;
    }
    int r = nextEmpty / 9;
    int c = nextEmpty % 9;
    for (int v = 1; v <= 9; ++v) {
      this.board[r][c] = v;
      boolean isDone = this.solve();
      if (isDone) {
        return true;
      }
      this.board[r][c] = 0;
    }
    return false;
  }

  public String toString() {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        sb.append(board[i][j]);
      }
    }
    return sb.toString();
  }

  public static void main(String[] args) {
    String puzzle = "801340000430800107000060003208050009009000700600070804300010000105006042000024308";
    Sudoku s = Sudoku.fromString(puzzle);
    System.out.println(s);
    s.solve();
    System.out.println(s);
  }
}
