.section .libday

# seek_non_num - seek the cursor a0 forward to the next non number
# a0 - cursor
seek_non_num:
	ret

# seek_num - seek the cursor a0 forward to the next number
# a0 - cursor
seek_num:
	ret

# load_dual_list - load two columns from strings into two int list locations
# a0 - buffer location
# a1 - list1 location
# a2 - list2 location
.global load_dual_list
load_dual_list:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a0, 4(sp) # buffer loc / cursor
	sw a1, 8(sp) # list1
	sw a2, 12(sp) # list2

1: # load line
	lw a0, 4(sp)
	call stoi
	lw t0, 8(sp)
	sw a0, 0(t0) # store first int at list1 location
	addi t0, t0, 4
	sw t0, 8(sp) # increment location by 4

	lw a0, 4(sp)
	call seek_non_num
	call seek_num
	call stoi
	lw t0, 12(sp)
	sw a0, 0(t0) # store second int at list2 location
	addi t0, t0, 4
	sw t0, 12(sp) # increment location by 4
	call seek_non_num # a0 is at newline or null terminator
	lw t0, 0(a0) # load char at a0 into t0
	beqz t0, 2f # if null terminator, leave
	sw a0, 4(sp) # otherwise store cursor and repeat
	j 1b
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
