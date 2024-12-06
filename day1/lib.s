.section .lib

# seek_num - seek the cursor a0 forward to the next number
# a0 - cursor
.global seek_num
seek_num:
1:
	addi a0, a0, 1
	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, 1b
	li t1, '0'
	blt t0, t1, 1b
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
	lw a0, 4(sp)
	j 2f
1: # skip newline currently under cursor
	lw a0, 4(sp)
	addi a0, a0, 1
	sw a0, 4(sp)
2: # load line
	call stoi
	sw a1, 4(sp)
	lw t0, 8(sp)
	sw a0, 0(t0) # store first int at list1 location
	addi t0, t0, 4
	sw t0, 8(sp) # increment location by 4
	lw a0, 4(sp)
	call seek_num
	call stoi
	sw a1, 4(sp)
	lw t0, 12(sp)
	sw a0, 0(t0) # store second int at list2 location
	addi t0, t0, 4
	sw t0, 12(sp) # increment location by 4
	lb a0, 0(a1) # load char at cursor into a0
	bnez a0, 1b # if not null terminator, repeat
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
