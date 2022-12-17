
! INTEGER FUNCTION GET(ARRAY, I, J)
! INTEGER ARRAY(9,9), I, J
! GET = ARRAY(I,J)
! END FUNCTION GET

! SUBROUTINE SET(ARRAY, I, J, V)
! INTEGER ARRAY(9,9), I, J, V
! ARRAY(I,J) = V
! END SUBROUTINE SET

! INTEGER FUNCTION INDEX2I(INDEX)
! INTEGER INDEX
! INDEX2I = INDEX/9
! END FUNCTION INDEX2I

! INTEGER FUNCTION INDEX2J(INDEX)
! INTEGER INDEX
! INDEX2J = MOD(INDEX, 9)
! END FUNCTION INDEX2J

! INTEGER FUNCTION IJ2INDEX(I, J)
! INTEGER I, J
! IJ2INDEX = (I/3)*3 + (J/3)
! END FUNCTION IJ2INDEX

program read_file
  implicit none

  ! Declare an array to store the lines of the file
  character(len=256), allocatable :: lines(:)

  ! Declare an integer variable to store the number of lines in the file
  integer :: num_lines, len, i

  integer :: iostat, file
  character(len=256) :: line, input, expected, filename, error_msg
  integer, parameter :: MAX_LINE_LENGTH = 80
  integer, parameter :: UNABLE_TO_OPEN_FILE = 1
  integer, parameter :: UNABLE_TO_READ_FILE = 2
  integer, parameter :: UNABLE_TO_CLOSE_FILE = 3


  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! Read the filename from the command line argument
  if (command_argument_count() < 1) then
    print *, "Error: No filename provided"
    stop
  else
    call get_command_argument(1, filename)
  end if
  
  ! open(unit=10, file=filename, status='old', iostat=iostat)
  ! if (iostat /= 0) then
  !     error_msg = 'Error: unable to open file: ' // filename
  !     write(*,*) error_msg
  !     stop UNABLE_TO_OPEN_FILE
  ! endif

  ! num_lines = 0
  ! do
  !   read(10, '(a)', iostat=iostat) line
  !   if (iostat /= 0) exit
  !   len = len_trim(line)
  !   if (len > 0 .and. line(len: len) == ' ') then
  !     line = adjustl(line)
  !   endif

  !   num_lines = num_lines + 1
  !   lines(num_lines) = line
  !   if (len > 0) then
  !     lines = adjustl(lines)
  !   endif
  ! enddo

  ! close(10)
  ! if (iostat /= 0) then
  !     error_msg = 'Error: unable to close file: ' // filename
  !     write(*,*) error_msg
  !     stop UNABLE_TO_CLOSE_FILE
  ! endif
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  ! Open the file for reading
  open(unit=10, file=filename, status="old")

  ! ! Determine the number of lines in the file
  ! inquire(unit=10, number=num_lines)

  ! ! Allocate the string array to the number of lines
  ! allocate(lines(num_lines))

  ! ! Iterate over the lines of the file
  ! do i = 1, num_lines
  !   ! Read the current line into the line variable
  !   read(unit=10, fmt="(a)", iostat=ios) line
  !   ! read(unit=10, fmt="(a)", advance="no") line
  
  !   ! Check for end-of-file
  !   if (ios /= 0) exit
  
  !   ! Store the line in the string array
  !   lines(i) = line
  ! end do

  ! ! Declare a string array
  ! character(len=256), allocatable :: str_array(:)
  
  ! ! Filter out any empty strings in the array
  ! do i = 1, size(str_array)
  !   if (trim(str_array(i)) /= "") then
  !     ! Keep the non-empty string
  !   else
  !     ! Remove the empty string
  !     str_array(i) = ""
  !   end if
  ! end do
  
  ! ! Compact the array to remove any empty elements
  ! str_array = str_array(1:count_nonblank(str_array))

  ! Read the lines of the file into the array
  num_lines = 0
  do
    num_lines = num_lines + 1
    lines = reshape(lines, (/ num_lines /))
    read(10, fmt="(a)", advance="no", iostat=iostat) line
    if (iostat /= 0) exit
    lines(num_lines) = line
  end do

  ! Close the file
  close(10)

  print *, "sssssssssssssudoku ", num_lines
  do i=1, size(lines, 1)-1, 2
      input = lines(i)
      expected = lines(i+1)
      print *, "Solved sudoku ", input, " in ", expected
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

  ! ! Declare variables
  ! character(len=*), intent(in) :: filename
  ! character(len=256) :: line
  ! integer :: ios

  ! ! Get the name of the file from the command line argument
  ! call get_command_arg(1, filename)

  ! ! Open the file for reading
  ! open(unit=10, file=filename, status='old', action='read')

  ! ! Read each line of the file and print it to the screen
  ! do
  !   read(10, '(a)', iostat=ios) line
  !   if (ios /= 0) exit
  !   write(*, '(a)') line
  ! end do

  ! ! Close the file
  ! close(10)
end program read_file