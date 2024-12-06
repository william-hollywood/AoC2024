.equ PUTS_LOC, 0x86000000
.equ UART_BASE, 0x10000000

.equ STACK_POS, 0x88000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

test1name: .string "puts - single character placed into a1: "
test1data: .string "h"
test2name: .string "puts - two characters placed into a1: "
test2data: .string "ha"
test3name: .string "stoi - integer parsed from string:\n"
test3data: .string "1094"
test3check1: .string "\tcheck int is correct: "
test3check2: .string "\tcheck a1 is cursor pos: "
test4name: .string "stoi - character before '0' terminates: "
test4data: .string "12/4"
test5name: .string "stoi - character after '9' terminates: "
test5data: .string "12:4"
test55name: .string "stoi - empty str: "
test55data: .string ":"
test6name: .string "test_eq_mem - Check eq mem: "
test6data: .string "string"
test7name: .string "test_eq_mem - Check neq mem: "
test7data: .string "str!ng"
test8name: .string "itos - normal number: "
test9name: .string "itos - negative number: "
test10name: .string "itos - zero: "
twelvestr: .string "12"
negtwelvestr: .string "-12"
zerostr: .string "0"

# Program main
.section .text
	call start

# TEST 1 - puts, one char
	la a0, test1name
	call print
	la a0, test1data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'h'
	mv a0, t0
	mv a1, t1
	call test_eq

# TEST 2 - puts two chars, last present
	la a0, test2name
	call print
	la a0, test2data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'a'
	mv a0, t0
	mv a1, t1
	call test_eq

# TEST 3 - stoi
	la a0, test3name
	call print
	la a0, test3data
	call stoi
	mv a3, a0
	mv a4, a1

	la a0, test3check1
	call print
	mv a0, a3
	li t0, 1094
	mv a1, t0
	call test_eq

	la a0, test3check2
	call print
	mv a1, a4
	la a0, test3data
	addi a0, a0, 4
	call test_eq

# TEST 4 - stoi character before '0'
	la a0, test4name
	call print
	la a0, test4data
	call stoi
	li t0, 12
	mv a1, t0
	call test_eq

# TEST 5 - stoi character after '9'
	la a0, test5name
	call print
	la a0, test5data
	call stoi
	li t0, 12
	mv a1, t0
	call test_eq

# TEST 5.5 - stoi of nothing
	la a0, test55name
	call print
	la a0, test55data
	call stoi
	li t0, 0
	mv a1, t0
	call test_eq

# TEST 6 - test_eq_str
	la a0, test6name
	call print
	la a0, test6data
	la a1, test6data
	li a2, 5
	call check_eq_mem
	mv a1, zero
	call test_eq

# TEST 7 - test_eq_str
	la a0, test7name
	call print
	la a0, test6data
	la a1, test7data
	li a2, 5
	call check_eq_mem
	mv a1, zero
	call test_neq

# TEST 8 - itos normal number
	la a0, test8name
	call print
	li a0, 12
	li a1, 0x87000000
	call itos
	la a0, twelvestr
	li a1, 0x87000000
	li a2, 3
	call check_eq_mem
	mv a1, zero
	call test_eq

# TEST 9 - itos negative number
	la a0, test9name
	call print
	li a0, -12
	li a1, 0x87000000
	call itos
	la a0, negtwelvestr
	li a1, 0x87000000
	li a2, 4
	call check_eq_mem
	mv a1, zero
	call test_eq

# TEST 10 - itos zero
	la a0, test10name
	call print
	li a0, 0
	li a1, 0x87000000
	call itos
	la a0, zerostr
	li a1, 0x87000000
	li a2, 2
	call check_eq_mem
	mv a1, zero
	call test_eq

# Print end
	call end

# Loop forever after main execution
loop: j loop

