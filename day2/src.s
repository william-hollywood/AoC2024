.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ ARR_POS, 0x87000000
.equ RESULT_LOC, 0x85000000

.section .data
newline: .string "\n"
ok: .string "OK\n"
phase1text: .string "Phase 1: Load file from stdin: "
part1text: .string "Part 1: count number of valid reports\nAnswer: "

# Program main
.section .text
	call start
	addi sp, sp, -16

	la a0, phase1text
	call print

	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets

	la a0, ok
	call print

	la a0, part1text
	call print

	li a0, FILE_BUFFER
	li a1, ARR_POS
	li a2, 1
	li a3, 3
	call count_reports

	la a1, RESULT_LOC
	call itos

	la a0, RESULT_LOC
	call print

	la a0, newline
	call print

	call end
