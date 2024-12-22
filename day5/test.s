.section .data
parse_all_rulesdata: .string "12|34\n56|78\n91|23\n\nS" # 'S' used to check what char we return
parse_all_rules1name: .string "parse_all_rules - loads page number rules into vector"

parse_page_list1data: .string "12,34,56,78,90\n" # see above
parse_page_list1name: .string "parse_all_rules - loads page numbers from line into vector"
parse_page_list2data: .string "87,65,43,21" # see above
parse_page_list2name: .string "parse_all_rules - loads page numbers from line into vector end of file"

process_rule1_name: .string "process rule - ensure p1 comes before p2"
process_rule2_name: .string "process rule - fail if p2 comes before p1"
process_rule3_name: .string "process rule - rule ignored if page not found"

process_single_page_listdata: .string "11,22,33,44,55\n"
process_single_page_list1name: .string "process_single_page_list - returns middle page if all rules pass"
process_single_page_list2name: .string "process_single_page_list - returns zero if any rule fails"

# using rules 11|22 and 22|33, 77 will be returned
process_page_listsdata: .string "11,22,33\n22,11,33\n44,55,66"
process_page_listsname: .string "process_page_lists - returns sum of successful rows"

process_filedata: .string "11|22\n22|33\n\n11,22,33\n22,11,33\n44,55,66"
process_filename: .string "process_file - file processed and evaluated"

process_file2data: .string "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n\n75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47"
process_file2name: .string "process_file - provided test\n"
process_file2check1: .string "\tvalid lines evaluted"
process_file2check2: .string "\tinvalid lines sorted to pass rules and summed"

recurse_gen_list1name: .string "recurse_gen_list - when called with 0 remaining, middle page returned"
recurse_gen_list2name: .string "recurse_gen_list - single page to order"
recurse_gen_list3name: .string "recurse_gen_list - three pages to order"

.equ TMP_VEC, 0x83800000
.equ RULE_VEC, 0x84000000
.equ PAGE_LIST_VEC, 0x84800000

# Program main
.section .text
	call start
	call test_start
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
	la a2, parse_all_rules1name
	call test_eq

# TEST recurse_gen_list
	la a0, recurse_gen_list1name
	call print

	# Populate the rule/page lists
	li t0, TMP_VEC # Remining items vector
	li t1, 0
	sw t1, 0(t0) # len 0

	li t0, PAGE_LIST_VEC # current page list vector
	li t1, 1
	sw t1, 0(t0)
	li t1, 22
	sw t1, 4(t0)

	li t0, RULE_VEC # rule vector (duh)
	li t1, 3
	sw t1, 0(t0)
	li t1, 11
	sw t1, 4(t0)
	li t1, 22
	sw t1, 8(t0) # 11|22
	li t1, 22
	sw t1, 12(t0)
	li t1, 33
	sw t1, 16(t0) # 22|33
	li t1, 11
	sw t1, 20(t0)
	li t1, 22
	sw t1, 24(t0) # 11|44

	li a0, TMP_VEC
	li a1, PAGE_LIST_VEC
	li a2, RULE_VEC
	call recurse_gen_list
	li a1, 22
	la a2, recurse_gen_list1name
	call test_eq

	# single page to order
	la a0, recurse_gen_list2name
	call print

	li t0, PAGE_LIST_VEC # current page list vector - empty
	li t1, 0
	sw t1, 0(t0)

	li t0, TMP_VEC # Remining items vector
	li t1, 1
	sw t1, 0(t0)
	li t1, 11
	sw t1, 4(t0)

	li a0, TMP_VEC
	li a1, PAGE_LIST_VEC
	li a2, RULE_VEC
	call recurse_gen_list
	li a1, 11
	la a2, recurse_gen_list2name
	call test_eq

	# three pages to order
	la a0, recurse_gen_list3name
	call print

	li t0, PAGE_LIST_VEC # current page list vector - empty
	li t1, 0
	sw t1, 0(t0)

	li t0, TMP_VEC # Remining items vector
	li t1, 3
	sw t1, 0(t0)
	li t1, 11
	sw t1, 4(t0)
	li t1, 33
	sw t1, 8(t0)
	li t1, 22
	sw t1, 12(t0)

	li a0, TMP_VEC
	li a1, PAGE_LIST_VEC
	li a2, RULE_VEC
	call recurse_gen_list
	li a1, 22
	la a2, recurse_gen_list3name
	call test_eq


# TEST parse_page_list

	la a0, parse_page_list1name
	call print

	la a0, parse_page_list1data
	li a1, PAGE_LIST_VEC
	call parse_page_list
	lb t0, 0(a0)
	li t1, '\n'
	bne t0, t1, 1f

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
1:
	li a1, 0
	la a2, parse_page_list1name
	call test_eq

	la a0, parse_page_list2name
	call print

	la a0, parse_page_list2data
	li a1, PAGE_LIST_VEC
	call parse_page_list
	lb t0, 0(a0)
	bnez t0, 1f

	li t0, TMP_VEC
	li t1, 4
	sw t1, 0(t0)
	li t1, 87
	sw t1, 4(t0)
	li t1, 65
	sw t1, 8(t0)
	li t1, 43
	sw t1, 12(t0)
	li t1, 21
	sw t1, 16(t0)

	li a0, PAGE_LIST_VEC
	li a1, TMP_VEC
	li a2, 20
	call memcmp
1:
	li a1, 0
	la a2, parse_page_list2name
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
	la a2, process_rule1_name
	call test_eq

	la a0, process_rule2_name
	call print
	li a0, 44
	li a1, 22
	li a2, PAGE_LIST_VEC
	call process_rule
	li a1, 0
	la a2, process_rule2_name
	call test_eq

	la a0, process_rule3_name
	call print
	li a0, 33
	li a1, 66
	li a2, PAGE_LIST_VEC
	call process_rule
	li a1, 1
	la a2, process_rule3_name
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

	lb t0, 0(a0)
	li t1, '\n'
	bne t0, t1, 1f
	li t0, 33
	bne a1, t0, 1f
	li a0, 0
	li a1, 0
	la a2, process_single_page_list1name
	call test_eq
	j 2f
1:
	li a0, 0
	li a1, 1
	la a2, process_single_page_list1name
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

	lb t0, 0(a0)
	li t1, '\n'
	bne t0, t1, 1f
	li t0, 0
	bne a1, t0, 1f
	li a0, 0
	li a1, 0
	la a2, process_single_page_list2name
	call test_eq
	j 2f
1:
	li a0, 0
	li a1, 1
	la a2, process_single_page_list2name
	call test_eq
2:

# TEST process_page_lists
	# modify rules
	li t0, RULE_VEC
	li t1, 22
	sw t1, 12(t0)
	li t1, 33
	sw t1, 16(t0) # 22|33

	la a0, process_page_listsname
	call print

	la a0, process_page_listsdata
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_page_lists
	li a1, 77
	la a2, process_page_listsname
	call test_eq

# TEST process_file

	la a0, process_filename
	call print

	la a0, process_filedata
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_file
	li a1, 77
	la a2, process_filename
	call test_eq

	la a0, process_file2name
	call print

	la a0, process_file2data
	li a1, RULE_VEC
	li a2, PAGE_LIST_VEC
	call process_file

	sw a0, 4(sp)
	sw a1, 8(sp)
	la a0, process_file2check1
	call print
	lw a0, 4(sp)
	li a1, 143
	la a2, process_file2check1
	call test_eq

	la a0, process_file2check2
	call print
	lw a0, 8(sp)
	li a1, 123
	la a2, process_file2check2
	call test_eq

	addi sp, sp, 16
# Print end
	call test_end
	call end
