.section .lib
.equ RULE_VEC, 0x84000000
.equ PAGE_LIST_VEC, 0x84800000

# parse_all_rules - parse all the rules in the input until a double newline
# a0 - buffer pos
.global parse_all_rules
parse_all_rules:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# parse_page_list - parse a list of pages and creating a vector of the result
.global parse_page_list
parse_page_list:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_single_page - process a single page and evaluate the rules of it
.global process_single_page
process_single_page:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_pages - process all pages returning a sum of all of the middle pages of valid lists
.global process_pages
process_pages:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# process_file - process an input file returning the sum of all of the middle pages of valid lists
.global process_file
process_file:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
