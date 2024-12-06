.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ RESULT_LOC, 0x85000000
.equ LIST1_POS, 0x87000000
.equ LIST2_POS, 0x87002000

.section .data
newline: .string "\n"
ok: .string "OK\n"
phase1text: .string "Phase 1: Load file from stdin: "
phase2text: .string "Phase 2: Parse dual lists: "
phase3text: .string "Phase 3: Sort List 1: "
phase4text: .string "Phase 4: Sort List 2: "
part1text: .string "Part 1: diff ordered two lists\nAnswer: "
part2text: .string "Part 2: calulate similarity score\nAnswer: "

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

	la a0, phase2text
	call print

	li a0, FILE_BUFFER
	li a1, LIST1_POS
	li a2, LIST2_POS
	call load_dual_list
	sw a0, 0(sp)

	la a0, ok
	call print

	la a0, phase3text
	call print

	li a0, LIST1_POS
	lw a1, 0(sp)
	call sort_list

	la a0, ok
	call print

	la a0, phase4text
	call print

	li a0, LIST2_POS
	lw a1, 0(sp)
	call sort_list

	la a0, ok
	call print

	la a0, part1text
	call print

	li a0, LIST1_POS
	li a1, LIST2_POS
	lw a2, 0(sp)
	call diff_lists

	la a1, RESULT_LOC
	call itos

	la a0, RESULT_LOC
	call print

	la a0, newline
	call print

	la a0, part2text
	call print

	addi sp, sp, 16
	call end
