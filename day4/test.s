.section .data
.equ TMP_ARR, 0x87f00000
parse_input_file1name: .string "parse_input_file - parse 2x2 file\n"
parse_input_file1data: .string "XM\nAS"
parse_input_file1check1: .string "\ta0 = 2: "
parse_input_file1check2: .string "\ta1 = 2: "
parse_input_filecheck3: .string "\tarr[][] = "
parse_input_filecheck3_2: .string ": "
parse_input_file1result: .string "XMAS"
parse_input_file2name: .string "parse_input_file - parse 3x3 file\n"
parse_input_file2data: .string "XMA\nSXM\nASX"
parse_input_file2check1: .string "\ta0 = 3: "
parse_input_file2check2: .string "\ta1 = 3: "
parse_input_file2result: .string "XMASXMASX"

# row_col_to_addr - check it works for rows
row_col_to_addrdata: .string "123456789"
row_col_to_addr1name: .string "row_col_to_addr - [0][0]: "
row_col_to_addr2name: .string "row_col_to_addr - [1][1]: "
row_col_to_addr3name: .string "row_col_to_addr - [2][2]: "

# move_delta_to_str
move_delta_to_str1name: .string "move_delta_to_str - R(0,1): "
move_delta_to_str1check: .string "456"
move_delta_to_str2name: .string "move_delta_to_str - DR(1,1): "
move_delta_to_str2check: .string "159"
move_delta_to_str3name: .string "move_delta_to_str - D(1,0): "
move_delta_to_str3check: .string "258"
move_delta_to_str4name: .string "move_delta_to_str - DL(1,-1): "
move_delta_to_str4check: .string "357"
move_delta_to_str5name: .string "move_delta_to_str - L(0,-1): "
move_delta_to_str5check: .string "654"
move_delta_to_str6name: .string "move_delta_to_str - UL(-1,-1): "
move_delta_to_str6check: .string "951"
move_delta_to_str7name: .string "move_delta_to_str - U(-1,0): "
move_delta_to_str7check: .string "852"
move_delta_to_str8name: .string "move_delta_to_str - UR(-1,1): "
move_delta_to_str8check: .string "753"

# Check each of the 8 search directions, U,D,L,R,UL,UR,DL,DR
search_pos_word_1_8: .string "ABC"
.equ search_pos_count_1_8, 1
.equ search_pos_xy_len_1_8, 3
search_pos1name: .string "search_pos[1][0] - check R(L->R): "
search_pos1data: .string "...ABC..."
.equ search_pos1_row_pos, 1
.equ search_pos1_col_pos, 0
search_pos2name: .string "search_pos[0][0] - check DR(TL->BR): "
search_pos2data: .string "A...B...C"
.equ search_pos2_row_pos, 0
.equ search_pos2_col_pos, 0
search_pos3name: .string "search_pos[0][1] - check D(U->D): "
search_pos3data: .string ".A..B..C."
.equ search_pos3_row_pos, 0
.equ search_pos3_col_pos, 1
search_pos4name: .string "search_pos[0][2] - check DL(TR->BL): "
search_pos4data: .string "..A.B.C.."
.equ search_pos4_row_pos, 0
.equ search_pos4_col_pos, 2
search_pos5name: .string "search_pos[1][2] - check L(R->L): "
search_pos5data: .string "...CBA..."
.equ search_pos5_row_pos, 1
.equ search_pos5_col_pos, 2
search_pos6name: .string "search_pos[2][2] - check UL(BR->TL): "
search_pos6data: .string "C...B...A"
.equ search_pos6_row_pos, 2
.equ search_pos6_col_pos, 2
search_pos7name: .string "search_pos[2][1] - check U(D->U): "
search_pos7data: .string ".C..B..A."
.equ search_pos7_row_pos, 2
.equ search_pos7_col_pos, 1
search_pos8name: .string "search_pos[2][0] - check UR(BL->TR): "
search_pos8data: .string "..C.B.A.."
.equ search_pos8_row_pos, 2
.equ search_pos8_col_pos, 0

# Check that the sum is returned if multiple of the checks are valid
search_pos_word_9: .string "AA"
.equ search_pos_count_9, 8
.equ search_pos_xy_len_9, 3
search_pos9name: .string "search_pos[1][1] - Sum all found (all 8 present): "
search_pos9data: .string "AAAAAAAAA"
.equ search_pos9_row_pos, 1
.equ search_pos9_col_pos, 1
# TODO: Check that the logic obeys row/col max and does not exceed any bounds
# NOTE: can do thing using a 4x4 grid, and passing in 3 instead of 4 to prevent a 4 long match

process_file1name: .string "process_file - 10x10 example: "
process_file1data: .string "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX"
process_file1search: .string "XMAS"
.equ process_file1check, 18

search_pos_cross1name: .string "search_pos_cross - present: "
search_pos_cross1data: .string "M.M.A.S.S"
search_pos_cross2name: .string "search_pos_cross - not present: "
search_pos_cross2data: .string "X.X.A.X.X"

process_file_cross1name: .string "process_file_cross - 10x10 example: "
.equ process_file_cross1check, 9

# Program main
.section .text
	call start
	addi sp, sp, -16

# TEST parse_input_file
	la a0, parse_input_file1name
	la a1, parse_input_file1data
	la a2, parse_input_file1check1
	li a3, 2
	la a4, parse_input_file1check2
	li a5, 2
	la a6, parse_input_file1result
	call test_parse_input_file

	la a0, parse_input_file2name
	la a1, parse_input_file2data
	la a2, parse_input_file2check1
	li a3, 3
	la a4, parse_input_file2check2
	li a5, 3
	la a6, parse_input_file2result
	call test_parse_input_file

# TEST move_delta_to_str

# TEST row_col_to_addr
	la a0, row_col_to_addr1name
	call print

	la a0, row_col_to_addrdata
	li a1, 3
	li a2, 0
	li a3, 0
	call row_col_to_addr
	lb a0, 0(a0)
	li a1, '1'
	call test_eq

	la a0, row_col_to_addr2name
	call print
	la a0, row_col_to_addrdata
	li a1, 3
	li a2, 1
	li a3, 1
	call row_col_to_addr
	lb a0, 0(a0)
	li a1, '5'
	call test_eq

	la a0, row_col_to_addr3name
	call print
	la a0, row_col_to_addrdata
	li a1, 3
	li a2, 2
	li a3, 2
	call row_col_to_addr
	lb a0, 0(a0)
	li a1, '9'
	call test_eq


# TEST move_delta_to_str
	la a0, move_delta_to_str1name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos1_row_pos
	li a3, search_pos1_col_pos
	li a4, 3
	li a5, 0
	li a6, 1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str1check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str2name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos2_row_pos
	li a3, search_pos2_col_pos
	li a4, 3
	li a5, 1
	li a6, 1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str2check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str3name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos3_row_pos
	li a3, search_pos3_col_pos
	li a4, 3
	li a5, 1
	li a6, 0
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str3check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str4name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos4_row_pos
	li a3, search_pos4_col_pos
	li a4, 3
	li a5, 1
	li a6, -1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str4check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str5name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos5_row_pos
	li a3, search_pos5_col_pos
	li a4, 3
	li a5, 0
	li a6, -1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str5check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str6name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos6_row_pos
	li a3, search_pos6_col_pos
	li a4, 3
	li a5, -1
	li a6, -1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str6check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str7name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos7_row_pos
	li a3, search_pos7_col_pos
	li a4, 3
	li a5, -1
	li a6, 0
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str7check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

	la a0, move_delta_to_str8name
	call print
	la a0, row_col_to_addrdata
	li a1, search_pos_xy_len_1_8
	li a2, search_pos8_row_pos
	li a3, search_pos8_col_pos
	li a4, 3
	li a5, -1
	li a6, 1
	call move_delta_to_str

	li a0, TMP_ARR
	la a1, move_delta_to_str8check
	mv a2, a4 # str len
	call check_eq_mem
	li a1, 0
	call test_eq

# TEST seach_pos
	la a0, search_pos1name
	la a1, search_pos1data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos1_row_pos
	li a5, search_pos1_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos2name
	la a1, search_pos2data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos2_row_pos
	li a5, search_pos2_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos3name
	la a1, search_pos3data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos3_row_pos
	li a5, search_pos3_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos4name
	la a1, search_pos4data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos4_row_pos
	li a5, search_pos4_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos5name
	la a1, search_pos5data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos5_row_pos
	li a5, search_pos5_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos6name
	la a1, search_pos6data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos6_row_pos
	li a5, search_pos6_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos7name
	la a1, search_pos7data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos7_row_pos
	li a5, search_pos7_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos8name
	la a1, search_pos8data
	li a2, search_pos_xy_len_1_8
	li a3, search_pos_xy_len_1_8
	li a4, search_pos8_row_pos
	li a5, search_pos8_col_pos
	la a6, search_pos_word_1_8
	li a7, search_pos_count_1_8
	call test_search_pos

	la a0, search_pos9name
	la a1, search_pos9data
	li a2, search_pos_xy_len_9
	li a3, search_pos_xy_len_9
	li a4, search_pos9_row_pos
	li a5, search_pos9_col_pos
	la a6, search_pos_word_9
	li a7, search_pos_count_9
	call test_search_pos

	la a0, process_file1name
	call print

	la a0, process_file1data
	la a1, process_file1search
	call process_file
	li a1, process_file1check
	call test_eq

# TEST search_pos_cross

	la a0, search_pos_cross1name
	call print

	la a0, search_pos_cross1data
	li a1, 1
	li a2, 1
	li a3, 3
	call search_pos_cross

	li a1, 1
	call test_eq


	la a0, search_pos_cross2name
	call print

	la a0, search_pos_cross2data
	li a1, 1
	li a2, 1
	li a3, 3
	call search_pos_cross

	li a1, 0
	call test_eq

# TEST process_file_cross

	la a0, process_file_cross1name
	call print

	la a0, process_file1data
	call process_file_cross
	li a1, process_file_cross1check
	call test_eq

	addi sp, sp, 16
# Print end
	call end

test_parse_input_file:
	addi sp, sp, -48
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	sw a5, 20(sp)
	sw a6, 24(sp)

	call print
	lw a0, 4(sp)
	la a1, TMP_ARR
	call parse_input_file
	sw a0, 28(sp)
	sw a1, 32(sp)

	lw a0, 8(sp)
	call print
	lw a0, 12(sp)
	lw a1, 28(sp)
	call test_eq

	lw a0, 16(sp)
	call print
	lw a0, 20(sp)
	lw a1, 32(sp)
	call test_eq

	la a0, parse_input_filecheck3
	call print
	lw a0, 24(sp)
	call print
	la a0, parse_input_filecheck3_2
	call print

	la a0, TMP_ARR
	lw a1, 24(sp)
	lw t0, 12(sp)
	lw t1, 20(sp)
	mul a2, t0, t1
	call check_eq_mem
	mv a1, zero
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 48
	ret

test_search_pos:
	addi sp, sp, -32
	sw ra, 0(sp)

	# Store locals
	sw a1, 4(sp) # data
	sw a2, 8(sp) # row len of data
	sw a3, 12(sp) # col len of data
	sw a4, 16(sp) # row
	sw a5, 20(sp) # col
	sw a6, 24(sp) # search word
	sw a7, 28(sp) # expected count

	call print

	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	call search_pos
	lw a1, 28(sp)
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
