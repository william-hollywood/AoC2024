.equ TMP_POS, 0x86000000
.equ UART_BASE, 0x10000000

.equ STACK_POS, 0x88000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

puts1name: .string "puts - single character placed into a1"
puts1data: .string "h"
puts2name: .string "puts - two characters placed into a1"
puts2data: .string "ha"
seek_num1name: .string "seek_num - seek from non-number to number"
seek_num1data: .string "---123"
stoi1name: .string "stoi - integer parsed from string:\n"
stoi1data: .string "1094"
stoi1check1: .string "\tcheck int is correct"
stoi1check2: .string "\tcheck a1 is cursor pos"
stoi2name: .string "stoi - character before '0' terminates"
stoi2data: .string "12/4"
stoi3name: .string "stoi - character after '9' terminates"
stoi3data: .string "12:4"
stoi4name: .string "stoi - empty str"
stoi4data: .string ":"
memcmp1name: .string "memcmp - Check eq mem"
memcmp1data: .string "string"
memcmp2name: .string "memcmp - Check neq mem"
memcmp2data: .string "str!ng"
memcpy1name: .string "memcpy - copies 7 bytes"
itos1name: .string "itos - normal number"
itos2name: .string "itos - negative number"
itos3name: .string "itos - zero"
twelvestr: .string "12"
negtwelvestr: .string "-12"
zerostr: .string "0"

# Program main
.section .text
	call start
	call test_start

# TEST: puts, one char
	la a0, puts1name
	call print
	la a0, puts1data
	li a1, TMP_POS
	call puts

	li t1, TMP_POS
	lb t0, 0(t1)
	li t1, 'h'
	mv a0, t0
	mv a1, t1
	la a2, puts1name
	call test_eq

# TEST: puts two chars, last present
	la a0, puts2name
	call print
	la a0, puts2data
	li a1, TMP_POS
	call puts

	li t1, TMP_POS
	lb t0, 0(t1)
	li t1, 'a'
	mv a0, t0
	mv a1, t1
	la a2, puts2name
	call test_eq

# TEST: seek_num, seeks num
	la a0, seek_num1name
	call print
	la a0, seek_num1data
	call seek_num

	la a1, seek_num1data
	addi a1, a1, 3 # str + 3 = '1'
	la a2, seek_num1name
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
	la a2, stoi1name
	call test_eq

	la a0, stoi1check2
	call print
	mv a1, a4
	la a0, stoi1data
	addi a0, a0, 4
	la a2, stoi1name
	call test_eq

# TEST: stoi character before '0'
	la a0, stoi2name
	call print
	la a0, stoi2data
	call stoi
	li t0, 12
	mv a1, t0
	la a2, stoi2name
	call test_eq

# TEST: stoi character after '9'
	la a0, stoi3name
	call print
	la a0, stoi3data
	call stoi
	li t0, 12
	mv a1, t0
	la a2, stoi3name
	call test_eq

# TEST 5.5 - stoi of nothing
	la a0, stoi4name
	call print
	la a0, stoi4data
	call stoi
	li t0, 0
	mv a1, t0
	la a2, stoi4name
	call test_eq

# TEST: memcmp
	la a0, memcmp1name
	call print
	la a0, memcmp1data
	la a1, memcmp1data
	li a2, 5
	call memcmp
	mv a1, zero
	la a2, memcmp1name
	call test_eq

	la a0, memcmp2name
	call print
	la a0, memcmp1data
	la a1, memcmp2data
	li a2, 5
	call memcmp
	mv a1, zero
	la a2, memcmp2name
	call test_neq

# memcpy
	la a0, memcpy1name
	call print
	la a0, memcmp1data
	li a1, TMP_POS
	li a2, 7
	call memcpy
	call memcmp
	mv a1, zero
	la a2, memcpy1name
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
	call memcmp
	mv a1, zero
	la a2, itos1name
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
	call memcmp
	mv a1, zero
	la a2, itos2name
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
	call memcmp
	mv a1, zero
	la a2, itos1name
	call test_eq

	call test_libvec
bp:
# Print end
	call test_end
	call end
