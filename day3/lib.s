.section .data
mul_str: .string "mul("
do_str: .string "do()"
dont_str: .string "don't()"

.section .lib

# read_until_valid_mul - as it says on the tin
# a0 - cursor to start from
# Returns
# a0 - cursor to next char
# a1 - value 1
# a2 - value 2
.global read_until_valid_mul
read_until_valid_mul:
	addi sp, sp, -16
	sw ra, 0(sp)

1:
	# check for "mul(", if not, jump to increase
	mv a3, a0
	la a1, mul_str
	la a2, 4
	call check_eq_mem
	mv t0, a0
	mv a0, a3
	bnez t0, .L_check_toggle
	addi a0, a0, 4
	j .L_after_toggle
.L_check_toggle: # These are neat, wish i knew about them sooner
	beqz s0, 2f
	# memory doesn't match, check if it's a do/don't
	mv a3, a0
	la a1, do_str
	la a2, 4
	call check_eq_mem
	bnez a0, .L_check_dont
	li s1, 0
	j .L_toggled
.L_check_dont:
	mv a0, a3
	la a1, dont_str
	la a2, 7
	call check_eq_mem
	bnez a0, .L_toggled
	li s1, 1
.L_toggled:
	mv a0, a3
	j 2f
.L_after_toggle:
	# check for number of 1-3 digits, if not, jump to increase
	mv t5, a0 # used if we need to stoi

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 2f
	li t1, '0'
	blt t0, t1, 2f
	addi a0, a0, 1

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 8f
	li t1, '0'
	blt t0, t1, 8f
	addi a0, a0, 1

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 8f
	li t1, '0'
	blt t0, t1, 8f
	addi a0, a0, 1
8:
	# check for ',', if not, jump to increase
	li t0, ','
	lb t1, 0(a0)
	bne t0, t1, 2f
	addi a0, a0, 1

	# check for number of 1-3 digits, if not, jump to increase
	mv t6, a0 # used if we need to stoi

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 2f
	li t1, '0'
	blt t0, t1, 2f
	addi a0, a0, 1

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 9f
	li t1, '0'
	blt t0, t1, 9f
	addi a0, a0, 1

	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 9f
	li t1, '0'
	blt t0, t1, 9f
	addi a0, a0, 1
9:

	# check for ')', if not, jump to increase
	li t0, ')'
	lb t1, 0(a0)
	bne t0, t1, 2f
	addi a0, a0, 1

	# jump to leave
	j 3f
2:
	# increase a0 by 1, check to see if the next char is null, if it isn't repeat
	addi a0, a0, 1
	lb t0, 0(a0)
	beqz t0, 4f
	li t1, '\n'
	beq t0, t1, 4f
	j 1b
3:
	# leave
	# get both numbers, load into a1 & a2,
	mv a3, a0
	mv a0, t5
	call stoi
	mv t5, a0

	mv a0, t6
	call stoi
	mv a2, a0
	mv a1, t5

	mv a0, a3
	j 5f
4:
	li a1, 0
	li a2, 0
5:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_memory_string - read all valid mul instructions, calculate each then sum them
# a0 - cursor to start from
# Returns
# a0 - sum of valid mul operations
# a1 - !0 if the processing should take into account do/don'ts
.global process_memory_string
process_memory_string:
	addi sp, sp, -16
	sw ra, 0(sp)

	mv s0, a1 # Using this as a global thing
	sw zero, 4(sp)
1:
	call read_until_valid_mul
	lb t0, 0(a0)
	beqz t0, 2f
	mul t0, a1, a2
	lw t1, 4(sp)
	beqz s0, 4f
	bnez s1, 5f # if s0 is 1 and s1 is 1, then we don't add the number (we must have read a don't)
4:
	add t1, t0, t1
5:
	sw t1, 4(sp)
	j 1b
2:
	lw a0, 4(sp)

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
