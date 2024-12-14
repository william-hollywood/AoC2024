.section .data
parse_all_rulesdata: .string "12|34\n56|78\n91|23\n\nS" # 'S' used to check what char we return
parse_all_rules1name: .string "parse_all_rules - loads page number rules into vector: "
parse_page_listdata: .string "12,34,56,78,90\nS" # see above
parse_page_list1name: .string "parse_all_rules - loads page numbers from line into vector: "

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
	bne t0, t1, _parse_all_rules_fail

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
_parse_all_rules_fail:
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

	addi sp, sp, 16
# Print end
	call end
