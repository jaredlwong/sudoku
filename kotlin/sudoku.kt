import java.io.File

// Array is for objects, IntArray doesn't use boxing
class Sudoku(val board: IntArray) {

  // static methods go here
  companion object {
    fun fromString(puzzle: String): Sudoku {
      val board = IntArray(81)
      for (r in 0..8) {
        for (c in 0..8) {
          if (puzzle.get(r*9+c) == '.') {
            board[r*9+c] = 0
          } else {
            board[r*9+c] = Character.getNumericValue(puzzle.get(r*9+c))
          }
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

fun main(args: Array<String>) {
  if (args.size < 1) {
    println("Please provide the name of an input file as an argument.")
    System.exit(1)
  }
  val filename = args[0]
  val lines = mutableListOf<String>()
  File(filename).forEachLine { line ->
    val cleaned = line.trim()
    if (cleaned.length > 0) {
      lines.add(cleaned)
    }
  }

  for (i in 0 until lines.size step 2) {
    val input = lines[i]
    val expected = lines[i+1]
    val s = Sudoku.fromString(input)
    val start = System.nanoTime()
    s.solve()
    val output = s.toString()
    val end = System.nanoTime()
    if (output.equals(expected)) {
        println("Solved sudoku $input in ${end-start} ns")
    } else {
        println("Failed to solve sudoku $input. Expected $expected, got $output")
        System.exit(1)
    }
  }
}
