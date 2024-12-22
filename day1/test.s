.section .data
.equ LIST1_POS, 0x84000000
.equ LIST2_POS, 0x84001000
load_dual_list1name: .string "load_dual_list - loads numbers into lists:\n"
load_dual_list1check1: .string "\t[0][0] = 12345"
load_dual_list1check2: .string "\t[0][1] =  9876"
load_dual_list1check3: .string "\t[1][0] = 67890"
load_dual_list1check4: .string "\t[1][1] = 54321"
load_dual_list1check5: .string "\tlen = 8"
load_dual_list1data: .string "12345   67890\n09876   54321\0"
sort_list1name: .string "sort_list - list gets sorted:\n"
sort_list1check1: .string "\t[0] =  9876"
sort_list1check2: .string "\t[1] = 12345"
sort_list1check3: .string "\t[2] = 54321"
sort_list1check4: .string "\t[3] = 67890"
diff_lists1name: .string "diff_lists - return correct diff"
num_occurances1name: .string "num_occurances - return correct number"
similarity_score1name: .string "similarity_score - return correct score"

# Program main
.section .text
	call start
	call test_start

# TEST: load_dual_list, loads 2x2 of numbers
	la a0, load_dual_list1name
	call print
	la a0, load_dual_list1data
	li a1, LIST1_POS
	li a2, LIST2_POS
	call load_dual_list
	mv t6, a0

	la a0, load_dual_list1check1
	call print
	li a0, 12345
	li t1, LIST1_POS
	lw a1, 0(t1)
	la a2, load_dual_list1check1
	call test_eq

	la a0, load_dual_list1check2
	call print
	li a0,  9876
	li t1, LIST1_POS
	lw a1, 4(t1)
	la a2, load_dual_list1check2
	call test_eq

	la a0, load_dual_list1check3
	call print
	li a0, 67890
	li t1, LIST2_POS
	lw a1, 0(t1)
	la a2, load_dual_list1check3
	call test_eq

	la a0, load_dual_list1check4
	call print
	li a0, 54321
	li t1, LIST2_POS
	lw a1, 4(t1)
	la a2, load_dual_list1check4
	call test_eq

	la a0, load_dual_list1check5
	call print
	mv a0, t6
	mv a3, a0
	li a1, 8
	la a2, load_dual_list1check5
	call test_eq

# TEST: sort_list
	la a0, sort_list1name
	call print
	li t1, LIST1_POS
	li t0, 54321
	sw t0, 0(t1)
	li t0, 12345
	sw t0, 4(t1)
	li t0, 67890
	sw t0, 8(t1)
	li t0, 9876
	sw t0, 12(t1)

	li a0, LIST1_POS
	li a1, 16
	call sort_list

	li t1, LIST1_POS
	la a0, sort_list1check1
	call print
	li a0, 9876
	lw a1, 0(t1)
	la a2, sort_list1check1
	call test_eq

	la a0, sort_list1check2
	call print
	li a0,  12345
	li t1, LIST1_POS
	lw a1, 4(t1)
	la a2, sort_list1check2
	call test_eq

	la a0, sort_list1check3
	call print
	li a0, 54321
	li t1, LIST1_POS
	lw a1, 8(t1)
	la a2, sort_list1check3
	call test_eq

	la a0, sort_list1check4
	call print
	li a0, 67890
	li t1, LIST1_POS
	lw a1, 12(t1)
	la a2, sort_list1check4
	call test_eq

# TEST: diff_lists
	la a0, diff_lists1name
	call print
	li t1, LIST1_POS
	li t0, 4
	sw t0, 0(t1)
	li t0, 8
	sw t0, 4(t1)
	li t1, LIST2_POS
	li t0, 3
	sw t0, 0(t1)
	li t0, 10
	sw t0, 4(t1)

	li a0, LIST1_POS
	li a1, LIST2_POS
	li a2, 8
	call diff_lists

	li a1, 3
	la a2, diff_lists1name
	call test_eq

# TEST: num_occurances
	la a0, num_occurances1name
	call print

	li t1, LIST1_POS
	li t0, 4
	sw t0, 0(t1)
	li t0, 10
	sw t0, 4(t1)
	li t0, 4
	sw t0, 8(t1)
	li t0, 2
	sw t0, 12(t1)

	li a0, LIST1_POS
	li a1, 16
	li a2, 4
	call num_occurances

	li a1, 2
	la a2, num_occurances1name
	call test_eq

# TEST: similarity_score
	la a0, similarity_score1name
	call print

	li t1, LIST2_POS
	li t0, 10
	sw t0, 0(t1)
	li t0, 3
	sw t0, 4(t1)
	li t0, 4
	sw t0, 8(t1)
	li t0, 4
	sw t0, 12(t1)

	li a0, LIST1_POS
	li a1, LIST2_POS
	li a2, 16
	call similarity_score

	li a1, 26
	la a2, similarity_score1name
	call test_eq
# Print end
	call test_end
	call end
