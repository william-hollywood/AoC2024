.equ PUTS_LOC, 0x87000000
.equ UART_BASE, 0x10000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

test1name: .string "puts - single character placed into a1: "
test1data: .string "h"

# Program main
.section .text
# Print start
	la a0, startstr
	li a1, UART_BASE
	call puts

# TEST 1 - puts
	la a0, test1name
	li a1, UART_BASE
	call puts
bp:
	la a0, test1data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'h'
	bne t0, t1, 1f
	la a0, passedstr
	li a1, UART_BASE
	call puts
	j 2f
1:
	la a0, failedstr
	li a1, UART_BASE
	call puts
2:
# TEST 2 - gets

# Print end
	la a0, endstr
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop

