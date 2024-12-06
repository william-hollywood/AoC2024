.equ ARRAY_LOC, 0x86000000

.section .data
parse_report1name: .string "parse_report - correctly parses and returns len:\n"
parse_report1data: .string "7 9 10 11"
parse_report1check1: .string "\t[0] =  7: "
parse_report1check2: .string "\t[1] =  9: "
parse_report1check3: .string "\t[2] = 10: "
parse_report1check4: .string "\t[3] = 11: "
parse_report1check5: .string "\tlen = 16: "
is_only_inc_or_dec1name: .string "is_only_inc_or_dec - all incrementing: "
is_only_inc_or_dec2name: .string "is_only_inc_or_dec - all decrementing: "
is_only_inc_or_dec3name: .string "is_only_inc_or_dec - not all same: "
distance_check1name: .string "distance_check - all close enough: "
distance_check2name: .string "distance_check - too far apart: "
distance_check3name: .string "distance_check - too close together: "
is_report_safe1name: .string "is_report_safe - safe: "
is_report_safe2name: .string "is_report_safe - is_only_inc_or_dec fails: "
is_report_safe3name: .string "is_report_safe - distance_check fails: "
count_reports1name: .string "count_reports - counts corect number: "
count_reports1data: .string "1 2 3 4 5\n5 1 4 3 2\n5 4 3 2 1"

# Program main
.section .text
	call start
	addi sp, sp, -16

# TEST: parse_report
	la a0, parse_report1name
	call print
	la a0, parse_report1data
	li a1, ARRAY_LOC
	call parse_report
	sw a0, 0(sp)

	la a0, parse_report1check1
	call print
	li a0, 7
	li t1, ARRAY_LOC
	lw a1, 0(t1)
	call test_eq

	la a0, parse_report1check2
	call print
	li a0, 9
	li t1, ARRAY_LOC
	lw a1, 4(t1)
	call test_eq

	la a0, parse_report1check3
	call print
	li a0, 10
	li t1, ARRAY_LOC
	lw a1, 8(t1)
	call test_eq

	la a0, parse_report1check4
	call print
	li a0, 11
	li t1, ARRAY_LOC
	lw a1, 12(t1)
	call test_eq

	la a0, parse_report1check5
	call print
	li a0, 16
	lw a1, 0(sp)
	call test_eq

# TEST: is_only_inc_or_dec - all inc
	la a0, is_only_inc_or_dec1name
	call print
	li a0, ARRAY_LOC
	li t0, 7
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 9
	sw t0, 8(a0)
	li a1, 12
	call is_only_inc_or_dec
	li a1, 0
	call test_eq

# TEST: is_only_inc_or_dec - all dec
	la a0, is_only_inc_or_dec2name
	call print
	li a0, ARRAY_LOC
	li t0, 9
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 7
	sw t0, 8(a0)
	li a1, 12
	call is_only_inc_or_dec
	li a1, 0
	call test_eq

# TEST: is_only_inc_or_dec - not all same
	la a0, is_only_inc_or_dec3name
	call print
	li a0, ARRAY_LOC
	li t0, 7
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 7
	sw t0, 8(a0)
	li a1, 12
	call is_only_inc_or_dec
	li a1, 0
	call test_neq

# TEST: distance_check - all close enough
	la a0, distance_check1name
	call print
	li a0, ARRAY_LOC
	li t0, 1
	sw t0, 0(a0)
	li t0, 2
	sw t0, 4(a0)
	li t0, 5
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call distance_check
	li a1, 0
	call test_eq

# TEST: distance_check - too close together
	la a0, distance_check2name
	call print
	li a0, ARRAY_LOC
	li t0, 1
	sw t0, 0(a0)
	li t0, 1
	sw t0, 4(a0)
	li t0, 3
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call distance_check
	li a1, 0
	call test_neq

# TEST: distance_check - too far apart
	la a0, distance_check2name
	call print
	li a0, ARRAY_LOC
	li t0, 1
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 10
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call distance_check
	li a1, 0
	call test_neq

# TEST: is_report_safe - safe
	la a0, is_report_safe1name
	call print
	li a0, ARRAY_LOC
	li t0, 5
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 10
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call is_report_safe
	li a1, 0
	call test_eq

# TEST: is_report_safe - is_only_inc_or_dec fails
	la a0, is_report_safe2name
	call print
	li a0, ARRAY_LOC
	li t0, 1
	sw t0, 0(a0)
	li t0, 3
	sw t0, 4(a0)
	li t0, 2
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call is_report_safe
	li a1, 0
	call test_neq

# TEST: is_report_safe - distance_check fails
	la a0, is_report_safe3name
	call print
	li a0, ARRAY_LOC
	li t0, 1
	sw t0, 0(a0)
	li t0, 8
	sw t0, 4(a0)
	li t0, 10
	sw t0, 8(a0)
	li a1, 12
	li a2, 1
	li a3, 3
	call is_report_safe
	li a1, 0
	call test_neq

# TEST: count_reports - counts correct
	la a0, count_reports1name
	call print
	la a0, count_reports1data
	li a1, ARRAY_LOC
	li a2, 1
	li a3, 3
	call count_reports
	li a1, 2
	call test_eq

# Print end
	call end
