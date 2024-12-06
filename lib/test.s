.equ PUTS_LOC, 0x86000000
.equ UART_BASE, 0x10000000

.equ STACK_POS, 0x88000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

puts1name: .string "puts - single character placed into a1: "
puts1data: .string "h"
puts2name: .string "puts - two characters placed into a1: "
puts2data: .string "ha"
seek_num1name: .string "seek_num - seek from non-number to number: "
seek_num1data: .string "---123"
stoi1name: .string "stoi - integer parsed from string:\n"
stoi1data: .string "1094"
stoi1check1: .string "\tcheck int is correct: "
stoi1check2: .string "\tcheck a1 is cursor pos: "
stoi2name: .string "stoi - character before '0' terminates: "
stoi2data: .string "12/4"
stoi3name: .string "stoi - character after '9' terminates: "
stoi3data: .string "12:4"
stoi4name: .string "stoi - empty str: "
stoi4data: .string ":"
test_eq_mem1name: .string "test_eq_mem - Check eq mem: "
test_eq_mem1data: .string "string"
test_eq_mem2name: .string "test_eq_mem - Check neq mem: "
test_eq_mem2data: .string "str!ng"
itos1name: .string "itos - normal number: "
itos2name: .string "itos - negative number: "
itos3name: .string "itos - zero: "
twelvestr: .string "12"
negtwelvestr: .string "-12"
zerostr: .string "0"

# Program main
.section .text
	call start

# TEST: puts, one char
	la a0, puts1name
	call print
	la a0, puts1data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'h'
	mv a0, t0
	mv a1, t1
	call test_eq

# TEST: puts two chars, last present
	la a0, puts2name
	call print
	la a0, puts2data
	li a1, PUTS_LOC
	call puts

	li t1, PUTS_LOC
	lb t0, 0(t1)
	li t1, 'a'
	mv a0, t0
	mv a1, t1
	call test_eq

# TEST: seek_num, seeks num
	la a0, seek_num1name
	call print
	la a0, seek_num1data
	call seek_num

	la a1, seek_num1data
	addi a1, a1, 3 # str + 3 = '1'
	call test_eq

# TEST: stoi
	la a0, stoi1name
	call print
	la a0, stoi1data
	call stoi
	mv a3, a0
	mv a4, a1

	la a0, stoi1check1
	call print
	mv a0, a3
	li t0, 1094
	mv a1, t0
	call test_eq

	la a0, stoi1check2
	call print
	mv a1, a4
	la a0, stoi1data
	addi a0, a0, 4
	call test_eq

# TEST: stoi character before '0'
	la a0, stoi2name
	call print
	la a0, stoi2data
	call stoi
	li t0, 12
	mv a1, t0
	call test_eq

# TEST: stoi character after '9'
	la a0, stoi3name
	call print
	la a0, stoi3data
	call stoi
	li t0, 12
	mv a1, t0
	call test_eq

# TEST 5.5 - stoi of nothing
	la a0, stoi4name
	call print
	la a0, stoi4data
	call stoi
	li t0, 0
	mv a1, t0
	call test_eq

# TEST: test_eq_str
	la a0, test_eq_mem1name
	call print
	la a0, test_eq_mem1data
	la a1, test_eq_mem1data
	li a2, 5
	call check_eq_mem
	mv a1, zero
	call test_eq

# TEST: test_eq_str
	la a0, test_eq_mem2name
	call print
	la a0, test_eq_mem1data
	la a1, test_eq_mem2data
	li a2, 5
	call check_eq_mem
	mv a1, zero
	call test_neq

# TEST: itos normal number
	la a0, itos1name
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

# TEST: itos negative number
	la a0, itos2name
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

# TEST: itos zero
	la a0, itos3name
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
