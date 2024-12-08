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
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
