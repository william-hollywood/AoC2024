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

	# TODO

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_memory_string - read all valid mul instructions, calculate each then sum them
# a0 - cursor to start from
# Returns
# a0 - sum of valid mul operations
.global process_memory_string
process_memory_string:
	addi sp, sp, -16
	sw ra, 0(sp)

	# TODO

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
