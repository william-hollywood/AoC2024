.section .lib

.equ TMP_ARR, 0x87f00000

# parse_input_file - parse the file specified by a0 into a 2d array at location a1
# a0 - file to be parsed location
# a1 - output array location
# returns
# a0 - length per line
# a1 - number of lines
.global parse_input_file
parse_input_file:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw zero, 4(sp) # Line length
	sw zero, 8(sp) # Row count

	# Get length of line, store at 4(sp)
	mv t0, a0
.L_parse_input_file_increase:
	addi t0, t0, 1
	li t1, '\n'
	lb t2, 0(t0)
	bne t1, t2, .L_parse_input_file_increase
	# subtract difference
	sub t0, t0, a0
	sw t0, 4(sp)

	# Read line, place data into a1
.L_parse_input_file_read_line:
	lw t0, 8(sp) #increment row counter
	addi t0, t0, 1
	sw t0, 8(sp)
.L_parse_input_file_read_char:
	lb t0, 0(a0)
	addi a0, a0, 1
	li t1, '\n'
	beq t0, t1, .L_parse_input_file_read_line # if newline, read next line
	beqz t0, .L_parse_input_file_exit # If EOF (null byte) exit
	# otherwise, normal char, store char in arr
	sb t0, 0(a1)
	addi a1, a1, 1
	j .L_parse_input_file_read_char

.L_parse_input_file_exit:
	# Load return values from stack
	lw a0, 4(sp)
	lw a1, 8(sp)

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# search_pos - search the current position for a given string
# a0 - array_pos
# a1 - row len
# a2 - col len
# a3 - row pos
# a4 - col pos
# a5 - search string
# Returns
# a0 - number of strings at pos
.global search_pos
search_pos:
	addi sp, sp, -48
	sw ra, 0(sp)
	
	# 4(sp) - string len
	# 8(sp) - string len - 1
	# Store these, because we'll need them later
	sw a0, 12(sp) # array_pos
	sw a1, 16(sp) # row len
	sw a2, 20(sp) # col len
	sw a3, 24(sp) # row pos
	sw a4, 28(sp) # col pos
	sw a5, 32(sp) # search string

	# Get search string length, store at 4(sp)
	mv t0, a5
.L_search_pos_increase:
	addi t0, t0, 1
	lb t1, 0(t0)
	bnez t1, .L_search_pos_increase
	# subtract difference
	sub t0, t0, a5
	sw t0, 4(sp)
	addi t0, t0, -1
	sw t0, 8(sp)

	# Check if we can read in each direction set a bit in s0 for each:
	mv s0, zero
	# Right: (col pos + (str len - 1)) < col len
	# Sets 0x0001
	mv t0, a4
	lw t1, 8(sp)
	add t0, t0, t1
	mv t1, a2
	slt t2, t0, t1
	beqz t2, .L_search_pos_can_down
	li t3, 1
	or s0, s0, t3

.L_search_pos_can_down:
	# Down: (row pos + (str len - 1)) < row len
	# Sets 0x0010
	mv t0, a3
	lw t1, 8(sp)
	add t0, t0, t1
	mv t1, a1
	slt t2, t0, t1
	beqz t2, .L_search_pos_can_left
	li t3, 1
	sll t3, t3, 1
	or s0, s0, t3

.L_search_pos_can_left:
	# Left: (col pos - (str len - 1)) > -1 (>= 0)
	# Sets 0x0100
	mv t0, a4
	lw t1, 8(sp)
	sub t0, t0, t1
	li t1, -1
	slt t2, t1, t0
	beqz t2, .L_search_pos_can_up
	li t3, 1
	sll t3, t3, 2
	or s0, s0, t3

.L_search_pos_can_up:
	# Up: (row pos - (str len - 1)) > -1 (>= 0)
	# Sets 0x1000
	mv t0, a3
	lw t1, 8(sp)
	sub t0, t0, t1
	li t1, -1
	slt t2, t1, t0
	beqz t2, .L_search_pos_find
	li t3, 1
	sll t3, t3, 3
	or s0, s0, t3

.L_search_pos_find:
	# From that we can see if we can do all 8
	mv t6, zero # reset counter reg
	# Looking clockwise from R
	# R:  0x0001
.L_search_pos_R:
	# Check to see if the mask matches
	li t0, 0x0001
	and t1, s0, t0
	bne t0, t1, .L_search_pos_D # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw t0, 16(sp)
	lw t1, 24(sp)
	mul t0, t0, t1 # row offset
	lw t1, 28(sp)
	add t0, t0, t1 # col offset
	lw t1, 12(sp)
	add t0, t0, t1 # add base offset

	mv a0, t0
	lw a1, 32(sp) # search str
	lw a2, 4(sp)  # str len
	call check_eq_mem
	bnez a0, .L_search_pos_DR # if mem doesn't match, go next
	addi t6, t6, 1

	# DR: 0x0011
.L_search_pos_DR:
	# D:  0x0010
.L_search_pos_D:
	# DL: 0x0110
.L_search_pos_DL:
	# L:  0x0100
.L_search_pos_L:
	# UL: 0x1100
.L_search_pos_UL:
	# U:  0x1000
.L_search_pos_U:
	# UR: 0x1001
.L_search_pos_UR:

	mv zero, s0
	mv a0, t6
	lw ra, 0(sp)
	addi sp, sp, 48
	ret
