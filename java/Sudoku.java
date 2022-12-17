import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.lang.StringBuilder;
import java.util.ArrayList;
import java.util.List;


public class Sudoku {
  private final int[][] board;

  public Sudoku(int[][] board) {
    this.board = board;
  }

  public static Sudoku fromString(String puzzle) {
    int[][] board = new int[9][9];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        board[r][c] = puzzle.charAt(r*9+c) == '.' ? 0 : Character.getNumericValue(puzzle.charAt(r*9+c));
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

  public static List<String> readFile(String filename) throws FileNotFoundException, IOException {
    List<String> lines = new ArrayList<>();
    try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
      for (String line; (line = br.readLine()) != null; ) {
        String cleaned = line.strip();
        if (!cleaned.equals("")) {
          lines.add(cleaned);
        }
      }
    }
    return lines;
  }
  
  public static void solve(List<String> lines) {
    for (int i = 0; i < lines.size(); i += 2) {
      String input = lines.get(i);
      String expected = lines.get(i + 1);
      long start = System.nanoTime();
      Sudoku s = Sudoku.fromString(input);
      s.solve();
      String output = s.toString();
      long end = System.nanoTime();
      if (output.equals(expected)) {
        System.out.println(String.format("Solved sudoku %s in %f ms", input, (end - start) / 1000000.0));
      } else {
        System.out.println(String.format("Failed to solve sudoku %s. Expected %s, got %s", input, expected, output));
        System.exit(1);
      }
    }
  }

  public static void main(String[] args) throws FileNotFoundException, IOException {
    if (args.length < 1) {
      System.out.println("Please provide the name of an input file as an argument.");
      System.exit(1);
    }
    String filename = args[0];
    List<String> lines = readFile(filename);
    solve(lines);
  }
}
