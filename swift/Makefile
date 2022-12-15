.PHONY: run

run:
	swiftc sudoku.swift
	./sudoku ../inputs/only_hard.txt

debug:
	swiftc -g sudoku.swift
	./sudoku ../inputs/only_hard.txt
	lldb (run) bt
