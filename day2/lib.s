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
	# Function here

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# is_only_inc_or_dec
# a0 - report array pos
# a1 - report array len
# Returns
# a0 - !0 if the report only increments or decrements
.global is_only_inc_or_dec
is_only_inc_or_dec:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# distance_check
# a0 - report array pos
# a1 - report array len
# a2 - min distance
# a3 - max distance
# Returns
# a0 - !0 if the report values are least a1 apart and at most a2 part
.global distance_check
distance_check:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
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
# a0 - !0 is the report is safe
.global is_report_safe
is_report_safe:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
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
