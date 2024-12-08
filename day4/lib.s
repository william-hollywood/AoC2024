.section .lib

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
.global search_pos
search_pos:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here

	# Get search string length, store at 4(sp)
	mv t0, a5
.L_search_pos_increase:
	addi t0, t0, 1
	lb t1, 0(t0)
	bnez t1, .L_search_pos_increase
	# subtract difference
	sub t0, t0, a0
	sw t0, 4(sp)

	# Check if we can read in each direction set a bit in s0 for each:
	mv zero, s0
	# Up (col pos >= (str len - 1)) 0x1
	
	# Down ((col len - col pos) < (str len - 1)) 0x10

	# Left (row pos >= (str len - 1)) 0x100
	
	# Right ((row len - row pos) < (str len - 1)) 0x1000

	# From that we can see if we can do all 8

	# U = 0x1

	# D = 0x10

	# L = 0x100

	# R = 0x1000

	# UL = 0x101

	# UR = 0x1001

	# DL = 0x110

	# DR = 0x1010

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
