.section .lib
.equ LOADED_ARR, 0x87400000
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


# row_col_to_addr - read tin
# a0 - arr base addr
# a1 - row len
# a2 - row pos
# a3 - col pos
# Returns
# a0 - addr of char
.global row_col_to_addr
row_col_to_addr:
	addi sp, sp, -16
	sw ra, 0(sp)

	mul t0, a1, a2 # row offset
	add t0, t0, a3 # col offset
	add t0, t0, a0 # add base offset

	mv a0, t0
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# move_delta_to_str - take in a char row, col, deltas, and string len, move string into TMP_ARR
# a0 - src arr pos
# a1 row len
# a2 row pos
# a3 col pos
# a4 str len
# a5 row delta
# a6 col delta
# a7 search str
.global move_delta_to_str
move_delta_to_str:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a0, 4(sp) # array_pos
	sw a2, 8(sp)
	sw a3, 12(sp)
	li t5, TMP_ARR
	mv t6, a4
.L_move_delta_to_str_loop:
	lw a0, 4(sp)
	lw a2, 8(sp)
	lw a3, 12(sp)
	call row_col_to_addr
	lb t0, 0(a0)
	sb t0, 0(t5)

	lw t0, 8(sp)
	add t0, t0, a5
	sw t0, 8(sp)
	lw t0, 12(sp)
	add t0, t0, a6
	sw t0, 12(sp)

	addi t5, t5, 1
	addi t6, t6, -1
	bnez t6, .L_move_delta_to_str_loop

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

calc_and_cmp_str_from_move_delta:
	addi sp, sp, -16
	sw ra, 0(sp)

	call move_delta_to_str

	li a0, TMP_ARR
	mv a1, a7 # search str
	mv a2, a4 # str len
	call check_eq_mem

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
	# Sets 0b0001
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
	# Sets 0b0010
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
	# Sets 0b0100
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
	# Sets 0b1000
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
	mv s1, zero # reset counter reg
	# Looking clockwise from R
	# R:  0b0001
.L_search_pos_R:
	# Check to see if the mask matches
	li t0, 0b0001
	and t1, s0, t0
	bne t0, t1, .L_search_pos_D # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)  # str len
	li a5, 0
	li a6, 1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_DR # if mem doesn't match, go next
	addi s1, s1, 1

	# DR: 0b0011
.L_search_pos_DR:
	# Check to see if the mask matches
	li t0, 0b0011
	and t1, s0, t0
	bne t0, t1, .L_search_pos_D # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, 1
	li a6, 1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_D # if mem doesn't match, go next
	addi s1, s1, 1
	# D:  0b0010
.L_search_pos_D:
	# Check to see if the mask matches
	li t0, 0b0010
	and t1, s0, t0
	bne t0, t1, .L_search_pos_L # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, 1
	li a6, 0
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_DL # if mem doesn't match, go next
	addi s1, s1, 1
	# DL: 0b0110
.L_search_pos_DL:
	# Check to see if the mask matches
	li t0, 0b0110
	and t1, s0, t0
	bne t0, t1, .L_search_pos_L # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, 1
	li a6, -1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_L # if mem doesn't match, go next
	addi s1, s1, 1
	# L:  0b0100
.L_search_pos_L:
	# Check to see if the mask matches
	li t0, 0b0100
	and t1, s0, t0
	bne t0, t1, .L_search_pos_U # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, 0
	li a6, -1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_UL # if mem doesn't match, go next
	addi s1, s1, 1
	# UL: 0b1100
.L_search_pos_UL:
	# Check to see if the mask matches
	li t0, 0b1100
	and t1, s0, t0
	bne t0, t1, .L_search_pos_U # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, -1
	li a6, -1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_U # if mem doesn't match, go next
	addi s1, s1, 1
	# U:  0b1000
.L_search_pos_U:
	# Check to see if the mask matches
	li t0, 0b1000
	and t1, s0, t0
	bne t0, t1, .L_search_pos_end # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, -1
	li a6, 0
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_UR # if mem doesn't match, go next
	addi s1, s1, 1
	# UR: 0b1001
.L_search_pos_UR:
	# Check to see if the mask matches
	li t0, 0b1001
	and t1, s0, t0
	bne t0, t1, .L_search_pos_end # If not, skip to next possible one (skip DR)

	# Get address of char in the array
	lw a0, 12(sp) # array_pos
	lw a1, 16(sp) # row len
	lw a2, 24(sp) # row pos
	lw a3, 28(sp) # col pos
	lw a4, 4(sp)
	li a5, -1
	li a6, 1
	lw a7, 32(sp)
	call calc_and_cmp_str_from_move_delta

	bnez a0, .L_search_pos_end # if mem doesn't match, go next
	addi s1, s1, 1

.L_search_pos_end:
	mv a0, s1

	mv s0, zero
	mv s1, zero

	lw ra, 0(sp)
	addi sp, sp, 48
	ret


# process_file - process a file
# a0 - file data location
# a1 - string to search for
# returns
# a0 - number of string matches
.global process_file
process_file:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw zero, 24(sp) # word count

	# load input file
	li a1, LOADED_ARR
	call parse_input_file

	sw a0, 8(sp) # col len
	sw a1, 12(sp) # row len

	sw zero, 16(sp) # i / row iter
.L_process_file_outer:
	lw t0, 12(sp)
	lw t1, 16(sp)
	beq t0, t1, .L_process_file_outer_end
	sw zero, 20(sp) # j / col iter
.L_process_file_inner:
	lw t0, 8(sp)
	lw t1, 20(sp)
	beq t0, t1, .L_process_file_inner_end

	li a0, LOADED_ARR
	lw a1, 12(sp)
	lw a2, 8(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 4(sp)
	call search_pos
	lw t0, 24(sp)
	add t0, t0, a0
	sw t0, 24(sp)

	lw t0, 20(sp)
	addi t0, t0, 1
	sw t0, 20(sp)
	j .L_process_file_inner
.L_process_file_inner_end:
	lw t0, 16(sp)
	addi t0, t0, 1
	sw t0, 16(sp)
	j .L_process_file_outer
.L_process_file_outer_end:
	lw a0, 24(sp)
	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# search_pos_cross - search a position for "MAS" twice in a cross
# a0 - arr base
# a1 - row
# a2 - col
# a3 - row len
# returns
# a0 - !0 if "MAS" twice in a cross
.global search_pos_cross
search_pos_cross:
	addi sp, sp, -32
	sw ra, 0(sp)

	mv t4, zero # 'M' counter
	mv t5, zero # 'S' counter
	mv t6, zero # counter
	sw a0, 4(sp)
	sw a3, 8(sp)
	sw a1, 12(sp)
	sw a2, 16(sp)

	# if char is 'A'
	call row_col_to_addr
	lb t0, 0(a0)
	li t1, 'A'
	bne t0, t1, .L_search_pos_cross_end
	# check DR, DL, UL, UR for two 'M's and two 'S's

	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addi a2, a2, 1
	addi a3, a3, 1
	call row_col_to_addr
	lb t0, 0(a0)
	li t1, 'M'
	bne t0, t1, 1f
	addi t4, t4, 1
1:
	li t1, 'S'
	bne t0, t1, 2f
	addi t5, t5, 1
2:
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addi a2, a2, 1
	addi a3, a3, -1
	call row_col_to_addr
	lb t0, 0(a0)
	li t1, 'M'
	bne t0, t1, 1f
	addi t4, t4, 1
1:
	li t1, 'S'
	bne t0, t1, 2f
	addi t5, t5, 1
2:
	# UL
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addi a2, a2, -1
	addi a3, a3, -1
	call row_col_to_addr
	lb t0, 0(a0)
	li t1, 'M'
	bne t0, t1, 1f
	addi t4, t4, 1
1:
	li t1, 'S'
	bne t0, t1, 2f
	addi t5, t5, 1
2:
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addi a2, a2, -1
	addi a3, a3, 1
	call row_col_to_addr
	lb t0, 0(a0)
	li t1, 'M'
	bne t0, t1, 1f
	addi t4, t4, 1
1:
	li t1, 'S'
	bne t0, t1, 2f
	addi t5, t5, 1
2:
	li t0, 2
	bne t0, t4, .L_search_pos_cross_end
	bne t0, t5, .L_search_pos_cross_end
	addi t6, t6, 1
.L_search_pos_cross_end:
	mv a0, t6
	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# process_file_cross - Load and process a file counting all occurances of "MAS" in a cross
.global process_file_cross
process_file_cross:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw zero, 24(sp) # word count

	# load file into TMP_ARR
	li a1, LOADED_ARR
	call parse_input_file

	addi a0, a0, -1
	addi a1, a1, -1
	sw a0, 8(sp) # col len
	sw a1, 12(sp) # row len

	# for i/j = 1; i/j < row/col len - 1; i/j++
	# check pos for "MAS" twice in cross
	li t0, 1
	sw t0, 16(sp) # i / row iter
.L_process_file_cross_outer:
	lw t0, 12(sp)
	lw t1, 16(sp)
	beq t0, t1, .L_process_file_cross_outer_end
	li t0, 1
	sw t0, 20(sp) # j / col iter
.L_process_file_cross_inner:
	lw t0, 8(sp)
	lw t1, 20(sp)
	beq t0, t1, .L_process_file_cross_inner_end

	li a0, LOADED_ARR
	lw a1, 16(sp)
	lw a2, 20(sp)
	lw a3, 12(sp)
	addi a1, a1, 1

	call search_pos_cross
	lw t0, 24(sp)
	add t0, t0, a0
	sw t0, 24(sp)

	lw t0, 20(sp)
	addi t0, t0, 1
	sw t0, 20(sp)
	j .L_process_file_cross_inner
.L_process_file_cross_inner_end:
	lw t0, 16(sp)
	addi t0, t0, 1
	sw t0, 16(sp)
	j .L_process_file_cross_outer
.L_process_file_cross_outer_end:
	# return count
	lw a0, 24(sp)

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
