.section .lib

# parse_report
# convert str report into numeric array
# read report until newline or null terminator
# a0 - buffer pos
# a1 - output pos
# Returns
# a0 - list len
# a1 - buffer cursor
.global parse_report
parse_report:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a0, 4(sp) # initial buffer pos
	sw a1, 8(sp) # ouput pos
	sw zero, 12(sp) # cur len counter
	j 2f
1:
	mv a0, a1
2:
	call seek_num
	call stoi
	lw t0, 8(sp)
	sw a0, 0(t0) # store parsed at output pos
	addi t0, t0, 4
	sw t0, 8(sp) # increment output pos
	lw t0, 12(sp)
	addi t0, t0, 4
	sw t0, 12(sp) # increment cur len
	lb t0, 0(a1) # load char at cursor
	li t1, '\n'
	beq t0, t1, 3f # repeat if not newline or null
	li t1, 0
	beq t0, t1, 3f
	j 1b
3:
	lw a0, 12(sp) # load len from stack

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# is_only_inc_or_dec
# a0 - report array pos
# a1 - report array len
# Returns
# a0 - 0 if the report only increments or decrements
.global is_only_inc_or_dec
is_only_inc_or_dec:
	addi sp, sp, -16
	sw ra, 0(sp)

	# determine if first two increase or decrease
	lw t0, 0(a0)
	lw t1, 4(a0)
	li t5, 0 # how many time the rule was violated
	bgt t0, t1, 1f
	li t6, 1
	j 2f
1:
	li t6, 0
2: # t6 now has 0 if decreasing or 1 if increasing
	lw t0, 0(a0)
	lw t1, 4(a0)
	bnez t6, 3f
	slt t2, t0, t1
	j 4f
3:
	sgt t2, t0, t1
4:
	beqz t2, 5f
	addi t5, t5, 1
5:
	addi a0, a0, 4
	addi a1, a1, -4
	li t0, 4
	bne a1, t0, 2b
	mv a0, t5

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# distance_check
# a0 - report array pos
# a1 - report array len
# a2 - min distance
# a3 - max distance
# Returns
# a0 - 0 if the report values are least a1 apart and at most a2 part
.global distance_check
distance_check:
	addi sp, sp, -16
	sw ra, 0(sp)

	li t5, 0 # how many time the rule was violated
1:
	lw t0, 0(a0)
	lw t1, 4(a0)
	# check get difference
	sub t2, t0, t1
	bgez t2, 2f
	neg t2, t2
2: # t2 is abs difference
	blt t2, a2, 3f
	bgt t2, a3, 3f
	j 4f
3: # if breach rule, inc t5
	addi t5, t5, 1
4:
	# increase compare pos
	addi a0, a0, 4
	addi a1, a1, -4
	li t0, 4
	bne a1, t0, 1b
	mv a0, t5

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# is_report_safe
# check that
# - numbers only increase or decrease (only inc or dec func)
# - consecutive numbers are at least 1 apart and at most 3 (disance check func)
# a0 - report array pos
# a1 - report array len
# a2 - min distance
# a3 - max distance
# Returns
# a0 - 0 if is the report is safe
.global is_report_safe
is_report_safe:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	call distance_check
	bnez a0, 1f

	lw a0, 4(sp)
	lw a1, 8(sp)
	call is_only_inc_or_dec
	bnez a0, 1f
	li a0, 0
	j 2f
1:
	li a0, 1
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# count_reports
# count how many reports are safe
# a0 - buffer pos
# a1 - tmp array pos
# a2 - min distance
# a3 - max distance
# Returns
# a0 - number of safe reports
.global count_reports
count_reports:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw zero, 4(sp)
	sw a0, 8(sp)
	sw a1, 12(sp) # array pos

1:
	lw a0, 8(sp)
	lw a1, 12(sp)
	call parse_report
	sw a1, 8(sp)
	mv t0, a0
	lw a0, 12(sp)
	mv a1, t0
	call is_report_safe

	bnez a0, 2f
	lw t0, 4(sp)
	addi t0, t0, 1
	sw t0, 4(sp)
2:
	lw a0, 8(sp)
	lb t0, 0(a0)
	beqz t0, 3f
	j 1b
3:
	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# dampen_arr
# a0 - ARR pos
# a1 - ARR len
# a2 - dst arr_pos
# a3 - item to remove
.global dampen_arr
dampen_arr:
	addi sp, sp, -16
	sw ra, 0(sp)

	# t0 - cursor in arr
	# t1 - cursor in dst
	# t2 - count
	# t3 - num from arr

	mv t0, a0
	mv t1, a2
	li t2, 0
1:
	beq a3, t2, 2f # if offset is item to remove, dont store it, increment cursor only
	lw t3, 0(t0)
	sw t3, 0(t1)
	addi t1, t1, 4
2:
	addi t0, t0, 4
	addi t2, t2, 4
	bne t2, a1, 1b

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# count_dampened_reports
# count how many reports are safe if one of the values is removed
# a0 - buffer pos
# a1 - tmp array pos
# a2 - min distance
# a3 - max distance
# a4 - tmp tmp array pos
# Returns
# a0 - number of safe reports after dampening
.global count_dampened_reports
count_dampened_reports:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw zero, 4(sp)
	sw a0, 8(sp) # buffer pos
	sw a1, 12(sp) # array pos
	sw a2, 16(sp) # min diff
	sw a3, 20(sp) # max diff

	# get report from buffer

	# check if safe, if safe jump down to increase
	# run dampen_arr for i <= len_report
	# for each check if safe, if safe jump to increase, else repeat

	# if here, not safe, jump to check for end of buffer

	# increase, increase count 4(sp)

	# check if end of buffer
	# repeat if not end

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
