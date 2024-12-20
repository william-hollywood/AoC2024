.section .data
rulefailstr: .string "rule fail: ("
list_pass_str: .string "OK ("
comma: .string ", "
endbracket: .string ") "
newline: .string "\n"
.equ TMP_STR, 0x83800000

.section .lib
# parse_all_rules - parse all the rules in the input until a double newline
# a0 - buffer pos
# a1 - RULE_VEC pos
# returns
# a0 - addr of next char after double newline
.global parse_all_rules
parse_all_rules:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a1, 4(sp)
.L_parse_all_rules_loop:
	# do a stoi,
	call stoi
	sw a0, 12(sp)
	mv a0, a1

	# skip | char
	addi a0, a0, 1
	# do a stoi
	call stoi
	sw a0, 16(sp)
	sw a1, 8(sp)
	# push to RULE_VEC
	lw a0, 4(sp)
	mv a1, sp
	addi a1, a1, 12
	li a2, 8
	call vec_push
	# skip current char (newline) and jump to top
	lw a0, 8(sp)
	addi a0, a0, 1
	# if char not newline, repeat
	lb t0, 0(a0)
	li t1, '\n'
	bne t0, t1, .L_parse_all_rules_loop

	addi a0, a0, 1 # skip new double newline
	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# parse_page_list - parse a list of pages and creating a vector of the result
# a0 - buffer pos (starting at page list)
# a1 - PAGE_LIST_VEC pos
.global parse_page_list
parse_page_list:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw zero, 0(a1) # reset len to zero
	sw a1, 4(sp)
	# top:
.L_parse_page_list_loop:
	# do a stoi
	call stoi
	sw a0, 12(sp)
	sw a1, 8(sp)
	# push to PAGE_LIST_VEC
	lw a0, 4(sp)
	mv a1, sp
	addi a1, a1, 12
	li a2, 4
	call vec_push
	# if char is newline, exit
	lw a0, 8(sp)
	lb t0, 0(a0)
	li t1, '\n'
	beq t0, t1, .L_parse_page_list_exit
	beqz t0, .L_parse_page_list_exit
	addi a0, a0, 1 # skip comma
	# jump to top
	j .L_parse_page_list_loop
.L_parse_page_list_exit:

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_rule - ensure page 1 comes before page 2
# a0 - page 1
# a1 - page 2
# a2 - PAGE_LIST_VEC pos
# Returns
# a0 - 1 if the rule is met, 0 otherwise
.global process_rule
process_rule:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)

	# get position of page 1 in PAGE_LIST_VEC
	lw a0, 12(sp)
	mv a1, sp
	addi a1, a1, 4
	li a2, 4
	call vec_find
	sw a0, 16(sp)
	# get position of page 2 in PAGE_LIST_VEC
	lw a0, 12(sp)
	mv a1, sp
	addi a1, a1, 8
	li a2, 4
	call vec_find
	sw a0, 20(sp)

	# check if both pages exist in page list
	li t0, -1
	lw t1, 16(sp)
	beq t0, t1, .L_process_rule_pass
	lw t2, 20(sp)
	beq t0, t2, .L_process_rule_pass
	# check 1_pos < 2_pos return 1
	bgt t1, t2, .L_process_rule_fail
.L_process_rule_pass:
	li a0, 1
	j .L_process_rule_exit
.L_process_rule_fail:
bp:
	la a0, rulefailstr
	call print
	lw a0, 4(sp)
	li a1, TMP_STR
	call itos
	li a0, TMP_STR
	call print
	la a0, comma
	call print
	lw a0, 8(sp)
	li a1, TMP_STR
	call itos
	li a0, TMP_STR
	call print
	la a0, endbracket
	call print

	li a0, 0

.L_process_rule_exit:
	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# evaluate_rules - evaluate the rules on a given page list
# a0 - RULE_VEC
# a1 - PAGE_LIST_VEC
# Returns
# a0 - 1 if the list is valid, 0 otherwise
evaluate_rules:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	# for rule in rule list
	sw zero, 12(sp) # start at zero
	lw t0, 4(sp)
	lw t0, 0(t0)
	sw t0, 16(sp) # loop until
.L_evaluate_rules_loop:
	lw a0, 4(sp)
	lw a1, 12(sp)
	li a2, 8
	call vec_at
	lw a1, 4(a0)
	lw a0, 0(a0)
	lw a2, 8(sp)
	# process_rule
	call process_rule
	# if rule not met, return zero
	beqz a0, .L_evaluate_rules_fail
	lw t0, 12(sp)
	addi t0, t0, 1
	lw t1, 16(sp)
	# if end of RULE_VEC, jump end of loop
	beq t0, t1, .L_evaluate_rules_end_loop
	sw t0, 12(sp)
	# jump start of loop
	j .L_evaluate_rules_loop
.L_evaluate_rules_end_loop:
	la a0, list_pass_str
	call print
	li a0, 1
	j .L_evaluate_rules_exit
.L_evaluate_rules_fail:
	li a0, 0
.L_evaluate_rules_exit:

	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# process_single_page_list - parse and process a single page and evaluate the rules of it
# a0 - buffer pos
# a1 - RULE_VEC pos
# a2 - PAGE_LIST_VEC pos
# Returns
# a0 - cursor to next char after pages
# a1 - 0 if invalid list, middle page num if valid
# a2 - 0 if valid list, middle page num of rearranged if invalid
.global process_single_page_list
process_single_page_list:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)

	mv a1, a2
	call parse_page_list
	sw a0, 4(sp)

	la a0, newline
	call print
	mv s0, zero
	lw t0, 12(sp)
	lw s1, 0(t0)
	lw s2, 12(sp)
	addi s2, s2, 4
	j 2f
1:
	addi s0, s0, 1
	addi s2, s2, 4
2:
	beq s0, s1, 3f
	lw a0, 0(s2)
	li a1, TMP_STR
	call itos
	li a0, TMP_STR
	call print
	la a0, comma
	call print
	j 1b
3:

	lw a0, 8(sp)
	lw a1, 12(sp)
	call evaluate_rules

	beqz a0, .L_process_single_page_list_fail
	# get middle number from page list
	lw a0, 12(sp)
	# (PAGE_LIST_VEC-len / 2) + 1
	lw a1, 0(a0)
	li t0, 2
	div a1, a1, t0
	li a2, 4
	call vec_at
	# return page num
	lw a1, 0(a0)
	mv a2, zero

	mv s0, a0
	mv s1, a1
	lw a0, 0(a0)
	li a1, TMP_STR
	call itos
	li a0, TMP_STR
	call print
	la a0, endbracket
	call print
	mv a0, s0
	mv a1, s1

	j .L_process_single_page_list_exit
.L_process_single_page_list_fail:
	# get middle number from page list
	lw a0, 12(sp)
	# (PAGE_LIST_VEC-len / 2) + 1
	lw a1, 0(a0)
	li t0, 2
	div a1, a1, t0
	li a2, 4
	call vec_at
	# return page num

	mv a1, zero
	lw a2, 0(a0)
.L_process_single_page_list_exit:

	lw a0, 4(sp)

	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# process_page_lists - process all pagelists returning a sum of all of the middle pages of valid lists
# a0 - buffer pos
# a1 - RULE_VEC pos
# a2 - PAGE_LIST_VEC pos
# Returns
# a0 - sum of all of the middle pages of valid lists
.global process_page_lists
process_page_lists:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)
	sw zero, 12(sp) # sum counter
	addi a0, a0, -1
.L_process_page_lists_loop:
	lb t0, 0(a0)
	addi a0, a0, 1
	lw a1, 4(sp)
	lw a2, 8(sp)
	call process_single_page_list
	lw t0, 12(sp)
	add t0, t0, a1
	sw t0, 12(sp)
	lw t0, 16(sp)
	add t0, t0, a2
	sw t0, 16(sp)
	lb t0, 0(a0)
	bnez t0, .L_process_page_lists_loop

	# return sum
	lw a0, 12(sp)
	lw a1, 16(sp)

	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# process_file - process an input file returning the sum of all of the middle pages of valid lists
# a0 - input file buffer
# a1 - RULE_VEC pos
# a2 - PAGE_LIST_VEC pos
# Returns
# a0 - sum of all of the middle pages of valid lists
.global process_file
process_file:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)

	call parse_all_rules

	lw a1, 4(sp)
	lw a2, 8(sp)
	call process_page_lists

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# recurse_gen_list - recursively generate all permutations of a list
# a0 - Remaining items vector pos
# a1 - current page list vector
# a2 - RULE_VEC pos
# returns
# a0 - 0 if not a valid permutations, else zero
.global recurse_gen_list
recurse_gen_list:
	addi sp, sp, -32
	sw ra, 0(sp)
	# The idea here is that a0 and a1, do not need to be duplicated
	# if 0(a0) == 0
	# 	return middle number of a1
	# else
	# 	for add in 0(a0)
	# 		remove add from remaining
	# 		for insert_pos in len(a1)+1
	# 			insert a0(add) into a1(inset_pos)
	# 			if rules match
	# 				call recurse_gen_list
	# 				if return != 0
	# 					return return
	# 			remove add from a1(insert_pos)
	# 		add add back into remaining
	# 	return 0

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
