#!/bin/bash

function string_to_puzzle() {
    local input=$1
    local result=""
    for (( i=0; i<${#input}; i++ )); do
        if [[ ${input:$i:1} == "." ]]; then
            result+="0"
        else
            result+="${input:$i:1}"
        fi
    done
    echo -n "${result}"
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

function is_valid() {
  local grid="$1"

  for r in $(seq 0 8); do
    local row=""
    for c in $(seq 0 8); do
      row+="${grid:$((r * 9 + c)):1}"
    done
    if ! is_valid_row "$row"; then
      return 1
    fi
  done

  for c in $(seq 0 8); do
    local col=""
    for r in $(seq 0 8); do
      col+="${grid:$((r * 9 + c)):1}"
    done
    if ! is_valid_row "$col"; then
      return 1
    fi
  done

  for i in $(seq 0 8); do
    local box_row=$((i / 3))
    local box_col=$((i % 3))
    local box=""
    for r in $(seq $((box_row * 3)) $((box_row * 3 + 2))); do
      for c in $(seq $((box_col * 3)) $((box_col * 3 + 2))); do
        box+="${grid:$((r * 9 + c)):1}"
      done
    done
    if ! is_valid_row "$box"; then
      return 1
    fi
  done

  return 0
}

function next_open() {
    grid=$1
    for ((r=0; r<9; r++)); do
        for ((c=0; c<9; c++)); do
            if [[ ${grid:$((r*9+c)):1} == 0 ]]; then
                echo $((r*9+c))
                return
            fi
        done
    done
    echo -1
}

function solve() {
    local grid="$1"

    # Check if grid is valid
    if ! is_valid "$grid"; then
        return 1
    fi


    # Get next open position in grid
    local p=$(next_open "$grid")
    if [ "$p" -lt 0 ]; then
        echo "$grid"
        return 0
    fi

    # Try values from 1 to 9 at the open position
    for ((v=1; v<=9; v++)); do
        grid[p]="$v"
        result=$(solve "${1:0:$p}$v${1:$p+1}")
        if [ -n "$result" ]; then
            echo "$result"
            return 0
        fi
    done

    return 1
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
  parsed=$(string_to_puzzle "$input")
  output=$(solve "$parsed")
  end=$(date +%s)
  elapsed=$((end - start))
  if [ "$output" == "$expected" ]; then
    echo "Solved sudoku $input in $elapsed s"
  else
    echo "Failed to solve sudoku $input. Expected $expected, got $output"
  fi
done
