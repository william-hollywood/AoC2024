.section .lib

# parse_report
# convert str report into numeric array
# read report until newline or null terminator
# a0 - buffer pos
# a1 - output pos
# Returns
# a0 - list len
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
# a1 - min distance
# a2 - max distance
# Returns
# a0 - number of safe reports
.global count_reports
count_reports:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
