// Array is for objects, IntArray doesn't use boxing
class Sudoku(val board: IntArray) {

  // static methods go here
  companion object {
    fun fromString(puzzle: String): Sudoku {
      val board = IntArray(81)
      for (r in 0..8) {
        for (c in 0..8) {
          board[r*9+c] = Character.getNumericValue(puzzle.get(r*9+c))
        }
      }
      return Sudoku(board)
    }
  }

  fun isValid(): Boolean {
    // rows
    for (r in 0..8) {
      val seen = IntArray(10)
      for (c in 0..8) {
        val i = r * 9 + c
        if (board[i] > 0 && ++seen[board[i]] > 1) {
          return false
        }
      }
    }

    // cols
    for (c in 0..8) {
      val seen = IntArray(10)
      for (r in 0..8) {
        val i = r * 9 + c
        if (board[i] > 0 && ++seen[board[i]] > 1) {
          return false
        }
      }
    }

    // boxes
    for (b in 0..8) {
      val seen = IntArray(10)
      val boxRow = b / 3
      val boxCol = b % 3
      for (r in IntRange(boxRow * 3, boxRow * 3 + 2)) {
        for (c in IntRange(boxCol * 3, boxCol * 3 + 2)) {
          val i = r * 9 + c
          if (board[i] > 0 && ++seen[board[i]] > 1) {
            return false
          }
        }
      }
    }

    return true
  }

  fun nextEmpty(): Int {
    for (i in 0..80) {
      if (board[i] == 0) {
        return i
      }
    }
    return -1
  }

  fun solve(): Boolean {
    if (!this.isValid()) {
      return false
    }
    val nextEmpty = this.nextEmpty()
    // is complete
    if (nextEmpty < 0) {
      return true
    }
    val r = nextEmpty / 9
    val c = nextEmpty % 9
    for (v in 1..9) {
      this.board[r*9+c] = v
      val isDone = this.solve()
      if (isDone) {
        return true
      }
      this.board[r*9+c] = 0
    }
    return false
  }

  override fun toString(): String {
    // https://kotlinlang.org/docs/type-safe-builders.html
    return buildString {
      for (i in 0..80) {
        append(board[i])
      }
    }
  }
}

fun main() {
  val puzzle: String = "801340000430800107000060003208050009009000700600070804300010000105006042000024308"
  val s = Sudoku.fromString(puzzle)
  println(s)
  s.solve()
  println(s)
}
