.equ PUTS_LOC, 0x87000000
.equ UART_BASE, 0x10000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

test1name: .string "puts - single character placed into a1: "
test1data: .string "h"
test2name: .string "puts - two characters placed into a1: "
test2data: .string "ha"
test3name: .string "stoi - integer parsed from string: "
test3data: .string "1234"
test4name: .string "stoi - character before '0' terminates: "
test4data: .string "12/4"
test5name: .string "stoi - character after '9' terminates: "
test5data: .string "12:4"

.macro print s
	la a0, \s
	li a1, UART_BASE
	call puts
.endm

.macro check_eq rd1, rd2
	bne \rd1, \rd2, 1f
	print passedstr
	j 2f
1:
	print failedstr
2:
.endm

# Program main
.section .text
# Print start
	print startstr

# TEST 1 - puts, one char
	print test1name
	la a0, test1data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'h'
	check_eq t0, t1

# TEST 2 - puts two chars, last present
	print test2name
	la a0, test2data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'a'
	check_eq t0, t1

# TEST 3 - stoi
	print test3name
	la a0, test3data
	call stoi
	li t0, 1234
	check_eq a0, t0

# TEST 4 - stoi character before '0'
	print test4name
	la a0, test4data
	call stoi
	li t0, 12
	check_eq a0, t0

# TEST 4 - stoi character after '9'
	print test5name
	la a0, test5data
	call stoi
	li t0, 12
	check_eq a0, t0

# Print end
	print endstr

# Loop forever after main execution
loop: j loop

