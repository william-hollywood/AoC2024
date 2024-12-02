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
test6name: .string "check_eq_str - Check eq strs: "
test6data: .string "string"
test7name: .string "check_eq_str - Check neq strs: "
test7data: .string "str!ng"
test8name: .string "itos - normal number: "
test9name: .string "itos - negative number: "
test10name: .string "itos - zero: "
twelvestr: .string "12"
negtwelvestr: .string "12"
zerostr: .string "0"

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

.macro check_neq rd1, rd2
	beq \rd1, \rd2, 1f
	print passedstr
	j 2f
1:
	print failedstr
2:
.endm

.macro check_eq_mem rd1, rd2, len
	li t0, 0
	li t1, \len
1:
	beqz t1, 3f
	beq \rd1, \rd2, 2f
	addi t0, t0, 1
2:
	addi \rd1, \rd1, 1
	addi \rd2, \rd2, 1
	addi t1, t1, -1
	j 1b
3:
	mv a0, t0
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

# TEST 5 - stoi character after '9'
	print test5name
	la a0, test5data
	call stoi
	li t0, 12
	check_eq a0, t0

# TEST 6 - check_eq_str
	print test6name
	la a0, test6data
	la a1, test6data
	check_eq_mem a0, a1, 5
	check_eq a0, zero

# TEST 7 - check_eq_str
	print test7name
	la a0, test6data
	la a1, test7data
	check_eq_mem a0, a1, 5
	check_neq a0, zero

# TEST 8 - itos normal number
	print test8name
	li a0, 12
	li a1, 0x8700000
	call itos
	la a0, twelvestr
	check_eq_mem a0, a1, 3
	check_eq a0, zero

# TEST 9 - itos negative number
	print test9name
	li a0, -12
	li a1, 0x8700000
	call itos
	la a0, negtwelvestr
	check_eq_mem a0, a1, 4
	check_eq a0, zero

# TEST 10 - itos zero
	print test10name
	li a0, 0
	li a1, 0x8700000
	call itos
	la a0, zerostr
	check_eq_mem a0, a1, 2
	check_eq a0, zero

# Print end
	print endstr

# Loop forever after main execution
loop: j loop

