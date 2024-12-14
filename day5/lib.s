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
_parse_all_rules_loop:
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
	bne t0, t1, _parse_all_rules_loop

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

	sw a1, 4(sp)
	# top:
_parse_page_list_loop:
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
	beq t0, t1, _parse_page_list_exit
	addi a0, a0, 1 # skip comma
	# jump to top
	j _parse_page_list_loop
_parse_page_list_exit:
	addi a0, a0, 1 # skip newline

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
	addi sp, sp, -16
	sw ra, 0(sp)

	# get position of page 1 in PAGE_LIST_VEC
	# get position of page 2 in PAGE_LIST_VEC

	# if both pages exist and 1_pos < 2_pos return 1
	# else return 0
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_single_page - process a single page and evaluate the rules of it
# a0 - buffer pos
# a0 - RULE_VEC pos
# a1 - PAGE_LIST_VEC pos
# Returns
# a0 - 0 if invalid list, middle page num if valid
.global process_single_page
process_single_page:
	addi sp, sp, -16
	sw ra, 0(sp)
	# parse_page_list

	# for rule in rule list
	# if end of RULE_VEC, jump end of loop
	# process_rule
	# if rule not met, return zero
	# jump start of for
	# end of loop:

	# get middle number from page list
	# (PAGE_LIST_VEC-len / 2) + 1
	# return page num

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_pages - process all pages returning a sum of all of the middle pages of valid lists
# a0 - RULE_VEC pos
# a1 - PAGE_LIST_VEC pos
# Returns
# a0 - sum of all of the middle pages of valid lists
.global process_pages
process_pages:
	addi sp, sp, -16
	sw ra, 0(sp)

	# for page in PAGE_LIST_VEC
	# if end of PAGE_LIST_VEC, jump to end of loop
	# process_single_page
	# add return to sum
	# jump to start of for
	# end of loop:

	# return sum

	lw ra, 0(sp)
	addi sp, sp, 16
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

	# parse_all_rules
	# parse_page_list
	# process_pages
	# return result of process_pages

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
