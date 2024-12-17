.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ RULE_VEC, 0x85000000
.equ PAGE_LIST_VEC, 0x86000000
.equ RESULT_LOC, 0x84fff000

.section .data
newline: .string "\n"
ok: .string "OK\n"
phase1text: .string "Phase 1: Load file from stdin: "
part1text: .string "Part 1: Find all strings in word search\nAnswer: "
part2text: .string "Part 2: Sum sorted incorrect lines\nAnswer: "

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
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_file

	sw a1, 4(sp)

	la a1, RESULT_LOC
	call itos

	la a0, RESULT_LOC
	call print

	la a0, newline
	call print

	la a0, part1text
	call print

	lw a0, 4(sp)
	la a1, RESULT_LOC
	call itos

	la a0, RESULT_LOC
	call print

	la a0, newline
	call print

	addi sp, sp, 16
	call end
