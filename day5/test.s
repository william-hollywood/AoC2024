.section .data
parse_all_rulesdata: .string "12|34\n56|78\n91|23\n\nS" # 'S' used to check what char we return
parse_all_rules1name: .string "parse_all_rules - loads page number rules into vector: "

parse_page_listdata: .string "12,34,56,78,90\nS" # see above
parse_page_list1name: .string "parse_all_rules - loads page numbers from line into vector: "

process_rule1_name: .string "process rule - ensure p1 comes before p2: "
process_rule2_name: .string "process rule - fail if p2 comes before p1: "
process_rule3_name: .string "process rule - rule ignored if page not found: "

process_single_page_listdata: .string "11,22,33,44,55\n"
process_single_page_list1name: .string "process_single_page_list - returns middle page if all rules pass: "
process_single_page_list2name: .string "process_single_page_list - returns zero if any rule fails: "

.equ TMP_VEC, 0x83800000
.equ RULE_VEC, 0x84000000
.equ PAGE_LIST_VEC, 0x84800000

# Program main
.section .text
	call start
	addi sp, sp, -16

# TEST parse_all_rules
	la a0, parse_all_rules1name
	call print

	la a0, parse_all_rulesdata
	li a1, RULE_VEC
	call parse_all_rules
	lb t0, 0(a0)
	li t1, 'S'
	bne t0, t1, 1f

	li t0, TMP_VEC
	li t1, 3
	sw t1, 0(t0)
	li t1, 12
	sw t1, 4(t0)
	li t1, 34
	sw t1, 8(t0)
	li t1, 56
	sw t1, 12(t0)
	li t1, 78
	sw t1, 16(t0)
	li t1, 91
	sw t1, 20(t0)
	li t1, 23
	sw t1, 24(t0)

	li a0, RULE_VEC
	li a1, TMP_VEC
	li a2, 28
	call memcmp
1:
	li a1, 0
	call test_eq

# TEST parse_page_list

	la a0, parse_page_list1name
	call print

	la a0, parse_page_listdata
	li a1, PAGE_LIST_VEC
	call parse_page_list
	lb t0, 0(a0)
	li t1, 'S'
	bne t0, t1, _parse_page_list_fail

	li t0, TMP_VEC
	li t1, 5
	sw t1, 0(t0)
	li t1, 12
	sw t1, 4(t0)
	li t1, 34
	sw t1, 8(t0)
	li t1, 56
	sw t1, 12(t0)
	li t1, 78
	sw t1, 16(t0)
	li t1, 90
	sw t1, 20(t0)

	li a0, PAGE_LIST_VEC
	li a1, TMP_VEC
	li a2, 24
	call memcmp
_parse_page_list_fail:
	li a1, 0
	call test_eq

# TEST process_rule
	# Setup PAGE_LIST_VEC
	li t0, PAGE_LIST_VEC
	li t1, 5
	sw t1, 0(t0) # len 5
	li t1, 11
	sw t1, 4(t0)
	li t1, 22
	sw t1, 8(t0)
	li t1, 33
	sw t1, 12(t0)
	li t1, 44
	sw t1, 16(t0)
	li t1, 55
	sw t1, 20(t0)

	la a0, process_rule1_name
	call print
	li a0, 11
	li a1, 55
	li a2, PAGE_LIST_VEC
	call process_rule
	li a1, 1
	call test_eq

	la a0, process_rule2_name
	call print
	li a0, 44
	li a1, 22
	li a2, PAGE_LIST_VEC
	call process_rule
	li a1, 0
	call test_eq

	la a0, process_rule3_name
	call print
	li a0, 33
	li a1, 66
	li a2, PAGE_LIST_VEC
	call process_rule
	li a1, 1
	call test_eq

# TEST process_single_page_list

	# Setup RULE_VEC (using above test page vec)
	li t0, RULE_VEC
	li t1, 2
	sw t1, 0(t0) # len 5
	li t1, 11
	sw t1, 4(t0)
	li t1, 22
	sw t1, 8(t0) # 11|22 (passing)
	li t1, 22
	sw t1, 12(t0)
	li t1, 66
	sw t1, 16(t0) # 22|66 (passing, no 66)

	la a0, process_single_page_list1name
	call print

	la a0, process_single_page_listdata
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_single_page_list

	lw t0, 0(a0)
	li t1, '\n'
	bne t0, t1, 1f
	li t0, 33
	bne a1, t0, 1f
	li a0, 0
	li a1, 0
	call test_eq
	j 2f
1:
	li a0, 0
	li a1, 1
	call test_eq
2:

	la a0, process_single_page_list2name
	call print
	# modify rules so it fails
	li t0, RULE_VEC
	li t1, 33
	sw t1, 12(t0)
	li t1, 22
	sw t1, 16(t0) # 33|22 (failing)

	la a0, process_single_page_listdata
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_single_page_list

	lw t0, 0(a0)
	li t1, '\n'
	bne t0, t1, 1f
	li t0, 0
	bne a1, t0, 1f
	li a0, 0
	li a1, 0
	call test_eq
	j 2f
1:
	li a0, 0
	li a1, 1
	call test_eq
2:

	addi sp, sp, 16
# Print end
	call end
