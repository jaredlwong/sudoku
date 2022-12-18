#define GET(ARRAY, I, J) (ichar(ARRAY((I)*9+(J)+1)))
#define GETI(ARRAY, I) (ichar(ARRAY((I)+1)))
#define SET(ARRAY, I, J, V) ARRAY((I)*9+(J)+1) = achar(V)
#define INDEX2I(I) ((I)/9)
#define INDEX2J(I) (mod((I), 9))
#define IJ2INDEX(I, J) (((I)/3)*3+((J)/3))

subroutine print_sudoku(label, sudoku)
  character(*) :: label
  character, dimension(81) :: sudoku
  character, dimension(81) :: sudoku_str
  call sudoku_ints_to_chars(sudoku, sudoku_str)
  print *, label, sudoku_str
  flush(6)
end subroutine

! convert . to 0, and every other character to its integer value
subroutine sudoku_chars_to_ints(sudoku_str, sudoku)
  character, dimension(81) :: sudoku_str
  character, dimension(81) :: sudoku
  integer i
  do i = 1, 81
    if (sudoku_str(i) == '.') then
      sudoku(i) = achar(0)
    else
      sudoku(i) = achar(ichar(sudoku_str(i)) - ichar('0'))
    end if
  end do
end subroutine

! do the reverse, convert 0 to ., and every other integer to its character value
subroutine sudoku_ints_to_chars(sudoku, sudoku_str)
  character, dimension(81) :: sudoku
  character, dimension(81) :: sudoku_str
  integer i
  do i = 1, 81
    if (sudoku(i) == achar(0)) then
      sudoku_str(i) = '.'
    else
      sudoku_str(i) = achar(ichar(sudoku(i)) + ichar('0'))
    end if
  end do
end subroutine

! populate empty positions where the nth element is the index of the nth constant in the sudoku array
! return number of zero elements
function sudoku_zeros(board, constants) result(c)
  character, dimension(81), intent(in) :: board(81)
  character, dimension(81), intent(out) :: constants(81)
  integer :: i = 1, c
  c = 1
  do i = 1, 81
    if (ichar(board(i)) == 0) then
      constants(c) = achar(i-1)
      c = c + 1
    end if
  end do
  ! adjust for 1-indexing
  c = c - 1
end function

subroutine sudoku_rows(sudoku, rows)
  character, dimension(81), intent(in) :: sudoku
  character, dimension(81) :: rows
  integer :: i, j
  do i = 0, 8
    do j = 0, 8
      if (GET(sudoku, i, j) > 0) then
        SET(rows, i, GET(sudoku, i, j)-1, 1)
      end if
    end do
  end do
end subroutine sudoku_rows

subroutine sudoku_cols(sudoku, cols)
  character, dimension(81), intent(in) :: sudoku
  character, dimension(81) :: cols
  integer :: i, j
  do i = 0, 8
    do j = 0, 8
      if (GET(sudoku, j, i) > 0) then
        SET(cols, i, GET(sudoku, j, i)-1, 1)
      end if
    end do
  end do
end subroutine sudoku_cols

subroutine sudoku_sqrs(sudoku, sqrs)
  character, dimension(81), intent(in) :: sudoku
  character, dimension(81) :: sqrs
  integer :: i, j, k, l
  do i = 0, 2
    do j = 0, 2
      do k = i*3, i*3+2
        do l = j*3, j*3+2
          if (GET(sudoku, k, l) > 0) then
            SET(sqrs, i*3+j, GET(sudoku, k, l)-1, 1)
          end if
        end do
      end do
    end do
  end do
end subroutine sudoku_sqrs

function sudoku_solve(sudoku) result(solved)
  character, dimension(81) :: sudoku
  character, dimension(81) :: zeros
  character, dimension(81) :: rows, cols, sqrs
  integer :: num_consts
  integer :: cur_const, i, j, k
  logical :: solved
  integer :: sudoku_zeros

  ! fortran is extremely dumb, it doesn't clear local variables on subsequent function calls
  do k = 1, 81
    zeros(k) = achar(0)
    rows(k) = achar(0)
    cols(k) = achar(0)
    sqrs(k) = achar(0)
  end do
  cur_const = 0
  i = 0
  k = 0
  k = 0
  solved = .false.

  num_consts = sudoku_zeros(sudoku, zeros)

  call sudoku_rows(sudoku, rows)
  call sudoku_cols(sudoku, cols)
  call sudoku_sqrs(sudoku, sqrs)

  do
    if (GETI(sudoku, GETI(zeros, num_consts-1)) /= 0) then
      solved = .true.
      return
    endif
    i = INDEX2I(GETI(zeros, cur_const))
    j = INDEX2J(GETI(zeros, cur_const))
    SET(sudoku, i, j, 1)
    do
      ! check validity of sudoku board
      ! check if the i'th row already has the current element we just stored at sudoku[i][j]
      ! check if the j'th col already has the current element we just stored at sudoku[i][j]
      ! check if the square for the i,j element already has the current element we just stored at sudoku[i][j]
      if (.not. (GET(rows, i, GET(sudoku, i, j)-1) /= 0 .or. GET(cols, j, GET(sudoku, i, j)-1) /= 0 .or.  GET(sqrs, IJ2INDEX(i, j), GET(sudoku, i, j)-1) /= 0)) then
        exit
      endif
      ! if it isn't valid and we just tried 9, we need to backtrack
      if (GET(sudoku, i, j) == 9) then
        SET(sudoku, i, j, 0)
        cur_const = cur_const - 1
        i = INDEX2I(GETI(zeros, cur_const))
        j = INDEX2J(GETI(zeros, cur_const))
        do
          if (GET(sudoku, i, j) /= 9) exit
          SET(rows, i, GET(sudoku, i, j)-1, 0)
          SET(cols, j, GET(sudoku, i, j)-1, 0)
          SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 0)
          SET(sudoku, i, j, 0)
          cur_const = cur_const - 1
          i = INDEX2I(GETI(zeros, cur_const))
          j = INDEX2J(GETI(zeros, cur_const))
        enddo
        SET(rows, i, GET(sudoku, i, j)-1, 0)
        SET(cols, j, GET(sudoku, i, j)-1, 0)
        SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 0)
      endif
      SET(sudoku, i, j, GET(sudoku, i, j)+1)
    enddo
    ! once it is valid, we set the rows, cols, and sqrs arrays to reflect the new value
    SET(rows, i, GET(sudoku, i, j)-1, 1)
    SET(cols, j, GET(sudoku, i, j)-1, 1)
    SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 1)
    cur_const = cur_const + 1
  enddo
end function

program read_file
  use iso_fortran_env, only: int64
  implicit none

  ! Declare an array to store the lines of the file
  character(len=256), allocatable :: lines(:)

  ! Declare an integer variable to store the number of lines in the file
  integer :: num_lines = 0, i = 0, iostat = 0, k = 0

  character(len=256) :: line, line2, filename, error_msg
  character(len=81) :: input, sudoku_in, sudoku_out, sudoku, expected
  integer, parameter :: FID = 10
  integer, parameter :: MAX_LINE_LENGTH = 80
  integer, parameter :: UNABLE_TO_OPEN_FILE = 1
  integer, parameter :: UNABLE_TO_READ_FILE = 2
  integer, parameter :: UNABLE_TO_CLOSE_FILE = 3
  logical :: sudoku_solve, solved
  integer :: start, end
  integer(int64) :: count, count_rate, count_max

  ! Read the filename from the command line argument
  if (command_argument_count() < 1) then
    print *, "Error: No filename provided"
    stop
  else
    call get_command_argument(1, filename)
  end if

  ! open the file for reading
  open(unit=FID, file=filename, status="old")

  ! get number of lines
  do while (iostat == 0)
    num_lines = num_lines + 1
    read(FID, *, iostat=iostat) line
  end do
  num_lines = num_lines - 1

  ! allocate array of strings
  allocate(lines(num_lines))

  ! read the file contents
  rewind(FID)
  do i = 1, num_lines
    read(unit=FID, fmt='(a)') lines(i)
    ! lines(i) = line
  end do

  ! close the file
  close(FID)

  do i=1, size(lines, 1), 2
      line = lines(i)
      line2 = lines(i+1)

      ! input used later for printing
      input = line(1:81)
      ! this array is used for actually solving
      sudoku_in = line(1:81)
      ! this is used later for comparing the result
      expected = line2(1:81)

      call system_clock(count, count_rate, count_max)
      start = count
      flush(6)
      call sudoku_chars_to_ints(sudoku_in, sudoku)
      solved = sudoku_solve(sudoku)
      call sudoku_ints_to_chars(sudoku, sudoku_out)
      call system_clock(count, count_rate, count_max)
      end = count
      if (sudoku_out .eq. expected) then
        print *, "Solved sudoku ", input, " in ", (end-start), " ns"
      else
        print *, "Failed to solve sudoku ", input, ". Expected ", expected, ", got ", sudoku_out
        call exit(1)
      endif
      flush(6)
  end do
end program read_file
