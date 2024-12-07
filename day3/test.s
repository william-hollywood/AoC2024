.section .data
read_until_valid_mul1name: .string "read_until_valid_mul - valid mul command found:\n"
read_until_valid_mul1data: .string "mul(10,20)abc"
read_until_valid_mul1check1: .string "\ta0 = char after ')': "
.equ read_until_valid_mul1check1data, 10
read_until_valid_mul1check2: .string "\ta1 = 10: "
.equ read_until_valid_mul1check2data, 10
read_until_valid_mul1check3: .string "\ta2 = 20: "
.equ read_until_valid_mul1check3data, 20
read_until_valid_mul2name: .string "read_until_valid_mul - incorrect name not detected as mul:\n"
read_until_valid_mul2data: .string "nul(10,20)abc"
read_until_valid_mul2check1: .string "\ta0 = end of string: "
.equ read_until_valid_mul2check1data, 13
read_until_valid_mul2check2: .string "\ta1 = 0: "
.equ read_until_valid_mul2check2data, 0
read_until_valid_mul2check3: .string "\ta2 = 0: "
read_until_valid_mul3name: .string "read_until_valid_mul - number too large :\n"
read_until_valid_mul3data: .string "mul(1234,20)abc"
.equ read_until_valid_mul3check1data, 15
read_until_valid_mul3check1: .string "\ta0 = end of string: "
read_until_valid_mul3check2: .string "\ta1 = 0: "
.equ read_until_valid_mul3check2data, 0
read_until_valid_mul3check3: .string "\ta2 = 0: "
read_until_valid_mul4name: .string "read_until_valid_mul - only one number in mul:\n"
read_until_valid_mul4data: .string "mul(123)abc"
.equ read_until_valid_mul4check1data, 11
read_until_valid_mul4check1: .string "\ta0 = end of string: "
.equ read_until_valid_mul4check2data, 0
read_until_valid_mul4check2: .string "\ta1 = 0: "
read_until_valid_mul4check3: .string "\ta2 = 0: "

process_memory_string1name: .string "process_memory_string - read all valid: "
process_memory_string1data: .string "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

# Program main
.section .text
	call start
	addi sp, sp, -16
# Test - read_until_valid_mul
	la a0, read_until_valid_mul1name
	la a1, read_until_valid_mul1data
	la a2, read_until_valid_mul1check1
	la a3, read_until_valid_mul1check1data
	la a4, read_until_valid_mul1check2
	la a5, read_until_valid_mul1check2data
	la a6, read_until_valid_mul1check3
	la a7, read_until_valid_mul1check3data
	call read_until_valid_mul_helper

	la a0, read_until_valid_mul2name
	la a1, read_until_valid_mul2data
	la a2, read_until_valid_mul2check1
	la a3, read_until_valid_mul2check1data
	la a4, read_until_valid_mul2check2
	la a5, read_until_valid_mul2check2data
	la a6, read_until_valid_mul2check3
	la a7, read_until_valid_mul2check2data
	call read_until_valid_mul_helper

	la a0, read_until_valid_mul3name
	la a1, read_until_valid_mul3data
	la a2, read_until_valid_mul3check1
	la a3, read_until_valid_mul3check1data
	la a4, read_until_valid_mul3check2
	la a5, read_until_valid_mul3check2data
	la a6, read_until_valid_mul3check3
	la a7, read_until_valid_mul3check2data
	call read_until_valid_mul_helper

	la a0, read_until_valid_mul4name
	la a1, read_until_valid_mul4data
	la a2, read_until_valid_mul4check1
	la a3, read_until_valid_mul4check1data
	la a4, read_until_valid_mul4check2
	la a5, read_until_valid_mul4check2data
	la a6, read_until_valid_mul4check3
	la a7, read_until_valid_mul4check2data
	call read_until_valid_mul_helper

# Test - process_memory_string
	la a0, process_memory_string1name
	call print

	la a0, process_memory_string1data
	call process_memory_string

	li a1, 161
	call test_eq

	addi sp, sp, 16
# Print end
	call end

# a0 - addr of test name
# a1 - addr of test data
# a2 - addr of check 1 str
# a3 - check 1 value (a1 + a3 = check value loc)
# a4 - addr of check 2 str
# a5 - check 2 value
# a6 - addr of check 3 str
# a7 - check 3 value
.global read_until_valid_mul_helper
read_until_valid_mul_helper:
	addi sp, sp, -48
	sw ra, 0(sp)
bp3:
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw a7, 32(sp)

	call print
	lw a0, 4(sp)
	call read_until_valid_mul
	sw a0, 36(sp)
	sw a1, 40(sp)
	sw a2, 44(sp)

	# check a1 + a3 = a0 returned
	lw a0, 8(sp) # load a2
	call print
	lw a0, 36(sp) # a0 returned from func
	lw a1, 4(sp) # test data address passed in
	lw t3, 12(sp)
	add a1, a1, t3
	call test_eq

	# check a1 = a5
	mv a0, a4
	call print
	lw a0, 40(sp)
	lw a1, 24(sp)
	call test_eq

	# check a2 = a7
	mv a0, a6
	call print
	lw a0, 44(sp)
	lw a1, 32(sp)
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 48
	ret
