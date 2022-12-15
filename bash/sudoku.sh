#!/bin/bash

input=''
output=''
grid=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

function string_to_puzzle() {
  local i
    for (( i=0; i<${#input}; i++ )); do
        if [[ ${input:$i:1} == "." ]]; then
          grid[i]=0
        else
          grid[i]=$((${input:$i:1})) 
        fi
    done
}

function print_puzzle() {
  puzzle_to_string
  echo "$output"
}

function puzzle_to_string() {
    local e
    output=''
    for e in "${grid[@]}"; do
      if [[ $e == 0 ]]; then
        output+="."
      else
        output+="$e"
      fi
    done
}

function is_valid_row() {
    local row=$1
    local checkset=()
    local i

    # Initialize the check set with zeroes.
    for ((i = 0; i < 10; i++)); do
        checkset[$i]=0
    done

    # Increment the count of each character in the check set.
    for ((i = 0; i < ${#row}; i++)); do
        local c=${row:$i:1}
        checkset[$c]=$((checkset[$c] + 1))
    done

    # Check if all counts are less than or equal to 1.
    for ((i = 1; i < 10; i++)); do
        if [[ ${checkset[$i]} -gt 1 ]]; then
            return 1
        fi
    done

    return 0
}

is_valid_return=1
function is_valid() {
  is_valid_return=1
  local r
  local c
  for r in $(seq 0 8); do
    local row=""
    for c in $(seq 0 8); do
      row+="${grid[$((r * 9 + c))]}"
    done
    if ! is_valid_row "$row"; then
      return
    fi
  done

  for c in $(seq 0 8); do
    local col=""
    for r in $(seq 0 8); do
      col+="${grid[$((r * 9 + c))]}"
    done
    if ! is_valid_row "$col"; then
      return
    fi
  done

  local i
  for i in $(seq 0 8); do
    local box_row=$((i / 3))
    local box_col=$((i % 3))
    local box=""
    for r in $(seq $((box_row * 3)) $((box_row * 3 + 2))); do
      for c in $(seq $((box_col * 3)) $((box_col * 3 + 2))); do
        box+="${grid[$((r * 9 + c))]}"
      done
    done
    if ! is_valid_row "$box"; then
      return
    fi
  done

  is_valid_return=0
  return
}

next_open_return=0
function next_open() {
    next_open_return=-1
    local r
    local c
    for ((r=0; r<9; r++)); do
        for ((c=0; c<9; c++)); do
            # echo "--- $r $c $((r*9+c))"
            # s=$((r*9+c))
            # v=${grid[$s]}
            # echo $v

            # echo "${grid:$((r*9+c)):1}"
            # echo "---"
            # if [[ ${grid:$((r*9+c)):1} == 0 ]]; then
            if [[ ${grid[$((r*9+c))]} == 0 ]]; then
                next_open_return=$((r*9+c))
                return
            fi
        done
    done
}

solve_return=1
function solve() {
    solve_return=1
    # Check if grid is valid
    is_valid
    if [ $is_valid_return -eq 1 ]; then
        solve_return=1
        return
    fi

    next_open
    local p=$next_open_return

    # Get next open position in grid
    if [ $p -lt 0 ]; then
        solve_return=1
        return
    fi

    print_puzzle
    # Try values from 1 to 9 at the open position
    local v
    for ((v=1; v<=9; v++)); do
        grid[$p]=$v
        solve
        if [ $solve_return -eq 0 ]; then
            solve_return=0
            return
        fi
        grid[$p]=0
    done
    solve_return=1
}


# check if a filename was provided as an argument
if [ $# -eq 0 ]; then
  echo "Error: No filename provided"
  exit 1
fi

# assign the first argument to a variable
filename=$1

# check if the file exists
if [ ! -f $filename ]; then
  echo "Error: File does not exist"
  exit 1
fi

# initialize an empty array
lines=()

# read the file line by line
while read -r line; do
  # append each line to the array
  lines+=("$line")
done < $filename

for (( i=0; i<${#lines[@]} ; i+=2 )) ; do
  input="${lines[i]}"
  expected="${lines[i+1]}"
  start=$(date +%s)
  string_to_puzzle
  puzzle_to_string
  solve
  puzzle_to_string
  echo "$input $expected $output"
  # end=$(date +%s)
  # elapsed=$((end - start))

  # echo "$input $expected $output $grid"

  # if [ "$output" == "$expected" ]; then
  #   echo "Solved sudoku $input in $elapsed s"
  # else
  #   echo "Failed to solve sudoku $input. Expected $expected, got $output"
  # fi
done