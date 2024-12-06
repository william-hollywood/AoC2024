.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ RESULT_LOC, 0x85000000
.equ LIST1_POS, 0x87000000
.equ LIST2_POS, 0x87002000

.section .data
newline: .string "\n"

# Program main
.section .text
	call start
	addi sp, sp, -16

	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets

	li a0, FILE_BUFFER
	li a1, LIST1_POS
	li a2, LIST2_POS

	call load_dual_list
	sw a0, 0(sp)

	li a0, LIST1_POS
	lw a1, 0(sp)
	call sort_list

	li a0, LIST2_POS
	lw a1, 0(sp)
	call sort_list

	li a0, LIST1_POS
	li a1, LIST2_POS
	lw a2, 0(sp)
	call diff_lists

bp:

	la a1, RESULT_LOC
	call itos

	la a0, RESULT_LOC
	call print

	la a0, newline
	call print

	addi sp, sp, 16
	call end
