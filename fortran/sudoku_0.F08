#define GET(ARRAY, I, J) (ARRAY((I)*9+(J)))
#define SET(ARRAY, I, J, V) ARRAY((I)*9+(J)) = (V)
#define INDEX2I(INDEX) ((INDEX)/9)
#define INDEX2J(INDEX) ((INDEX)%9)
#define IJ2INDEX(I, J) (((I)/3)*3+((J)/3))

! convert . to 0, and every other character to its integer value
subroutine sudoku_chars_to_ints(sudoku)
  character, dimension(81) :: sudoku
  integer i
  do i = 1, 81
    if (sudoku(i) == '.') then
      sudoku(i) = achar(0)
    else
      sudoku(i) = achar(ichar(sudoku(i)) - ichar('0'))
    end if
  end do
end subroutine

! do the reverse, convert 0 to ., and every other integer to its character value
subroutine sudoku_ints_to_chars(sudoku)
  character, dimension(81) :: sudoku
  integer i
  do i = 1, 81
    if (sudoku(i) == achar(0)) then
      sudoku(i) = '.'
    else
      sudoku(i) = achar(ichar(sudoku(i)) + ichar('0'))
    end if
  end do
end subroutine

! return number of constants in array
integer function sudoku_constants(board, constants)
  character, dimension(81), intent(in) :: board(81)
  character, dimension(81), intent(out) :: constants(81)
  integer :: i = 1, c = 1
  do i = 1, 81
    if (board(i) == achar(0)) then
      constants(c) = achar(i)
      c = c + 1
    end if
  end do
  sudoku_constants = c
end function

subroutine sudoku_rows(sudoku, rows)
  character, dimension(81), intent(in) :: sudoku
  character, dimension(81), intent(out) :: rows
  integer :: i, j
  do i = 1, 9
    do j = 1, 9
      if (GET(sudoku, i, j) > achar(0)) then
        SET(rows, i, ichar(GET(sudoku, i, j))-1, achar(1))
      end if
    end do
  end do
end subroutine sudoku_rows

program read_file
  implicit none

  ! Declare an array to store the lines of the file
  character(len=256), allocatable :: lines(:)

  ! Declare an integer variable to store the number of lines in the file
  integer :: num_lines = 0, len = 0, i = 0, iostat = 0

  character(len=256) :: line, line2, filename, error_msg
  character(len=81) :: input, sudoku, expected
  integer, parameter :: FID = 10
  integer, parameter :: MAX_LINE_LENGTH = 80
  integer, parameter :: UNABLE_TO_OPEN_FILE = 1
  integer, parameter :: UNABLE_TO_READ_FILE = 2
  integer, parameter :: UNABLE_TO_CLOSE_FILE = 3

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
  print *, "Number of lines = ", num_lines

  ! allocate array of strings
  allocate(lines(num_lines))

  ! read the file contents
  rewind(FID)
  do i = 1, num_lines
    read(unit=FID, fmt='(a)') line
    lines(i) = trim(line)
  end do

  ! close the file
  close(FID)

  do i=1, size(lines, 1), 2
      line = lines(i)
      line2 = lines(i+1)

      ! input used later for printing
      input = line(1:81)
      ! this array is used for actually solving
      sudoku = line(1:81)
      ! this is used later for comparing the result
      expected = line2(1:81)

      write(*,*) trim(input)
      call sudoku_chars_to_ints(sudoku)
      call sudoku_ints_to_chars(sudoku)
      write(*,*) trim(sudoku)
      write(*,*) trim(expected)

      ! print *, "Solved sudoku ", input, " in ", expected
      ! s = string_to_puzzle(input)
      ! start = time()
      ! call solve(s)
      ! end = time()
      ! if (puzzle_to_string(s) .eq. expected) then
      !     print *, "Solved sudoku ", input, " in ", (end-start)*1000, " ms"
      ! else
      !     print *, "Failed to solve sudoku ", input, ". Expected ", expected, ", got ", s
      !     call exit(1)
      ! end if
  end do
end program read_file