.section .lib

# load_dual_list - load two columns from strings into two int list locations
# a0 - buffer location
# a1 - list1 location
# a2 - list2 location
# Return:
# a0 - list len
.global load_dual_list
load_dual_list:
	addi sp, sp, -16
	sw ra, 0(sp)

	li t6, 0 # len counter
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
	addi t6, t6, 4
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
	mv a0, t6
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# sort_list - sort the list at a0 from smallest to largest (in place)
# a0 - list location
# a1 - list len
.global sort_list
sort_list:
	addi sp, sp, -16
	sw ra, 0(sp)

	mv t6, a0
	mv t0, t6
	mv t1, t6
1:
	# t0 = current start
	# t1 = cursor
	# t2 = cursor num
	# t3 = smallest num
	# t4 = smallest addr
	# t5 = tmp
	# t6 = initial start

	# Check if next number after cursor is end of list
	sub t5, t1, t6
	beq t5, a1, 4f # leave if end of list
	lw t3, 0(t0)
	mv t4, t0

	# Find addr of smallest
2:
	# if cursor is smaller than current smallest, swap
	lw t2, 0(t1)
	bgt t2, t3, 3f
	mv t3, t2
	mv t4, t1
3:
	addi t1, t1, 4
	#Check if end of list
	sub t5, t1, t6
	bne t5, a1, 2b # repeat if not end

	lw t5, 0(t0)
	sw t3, 0(t0)
	sw t5, 0(t4)

	# Inc start, restart cursor, repeat
	addi t0, t0, 4
	mv t1, t0
	j 1b
4:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# diff_lists - sum the diffs of the lists
# a0 - List 1
# a1 - List 2
# a2 - len
# Returns
# a0 - diff sum
.global diff_lists
diff_lists:
	addi sp, sp, -16
	sw ra, 0(sp)

	# t0 - cur len
	# t1 - list 1 num
	# t2 - list 2 num
	# t3 - cur diff
	# t6 - diff sum
	li t0, 0
	li t6, 0
1:
	lw t1, 0(a0)
	lw t2, 0(a1)
	sub t3, t1, t2
	bgez t3, 2f
	neg t3, t3
2:
	add t6, t3, t6
	addi t0, t0, 4
	addi a0, a0, 4
	addi a1, a1, 4
	sub t5, t0, a2
	bnez t5, 1b # repeat if not end

	mv a0, t6
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# num_occurances - count the number of occurances of a number in a given list
# a0 - list
# a1 - len
# a2 - number
# returns
# a0 - count
.global num_occurances
num_occurances:
	addi sp, sp, -16
	sw ra, 0(sp)

	# t1 - cur len
	# t5 - count
	li t1, 0
	li t5, 0
1:
	lw t2, 0(a0)
	# increment len, cursor
	addi t1, t1, 4
	addi a0, a0, 4
	bne a2, t2, 2f
	addi t5, t5, 1
2:
	sub t2, t1, a1
	bnez t2, 1b # repeat if not end

	mv a0, t5

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# similarity_score - sum each num in left list times occurance in right
# a0 - list 1
# a1 - list 2
# a2 - len
# returns
# a0 - similarity score
.global similarity_score
similarity_score:
	addi sp, sp, -32
	sw ra, 0(sp)
	sw a0, 4(sp) # list 1 original
	sw a0, 8(sp) # list 1 cursor
	sw a1, 12(sp) # list 2
	sw a2, 16(sp) # len

	# t0 - cur len
	# t6 - similarity sum
	li t0, 0
	li t6, 0
1:
	lw a0, 12(sp) # load list2
	lw a1, 16(sp) # load len
	lw t5, 8(sp)
	lw t5, 0(t5)
	mv a2, t5 # load search num
	call num_occurances

	# add to sum
	mul t5, a0, a2
	add t6, t5, t6

	# increment len, cursor
	addi t0, t0, 4
	lw t1, 8(sp)
	addi t1, t1, 4
	# store cursor
	sw t1, 8(sp)
	lw t1, 16(sp)
	sub t1, t1, t0
	bnez t1, 1b # repeat if not end

	mv a0, t6
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
