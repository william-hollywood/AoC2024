.section .data
test1name: .string "seek_num - seek from non-number to number: "
test1data: .string "---123"
.equ LIST1_POS, 0x84000000
.equ LIST2_POS, 0x84001000
test2name: .string "load_dual_list - loads numbers into lists:\n"
test2check1: .string "\t[0][0] = 12345: "
test2check2: .string "\t[0][1] =  9876: "
test2check3: .string "\t[1][0] = 67890: "
test2check4: .string "\t[1][1] = 54321: "
test2check5: .string "\tlen = 8: "
test2data: .string "12345   67890\n09876   54321\0"
test3name: .string "sort_list - list gets sorted:\n"
test3check1: .string "\t[0] =  9876: "
test3check2: .string "\t[1] = 12345: "
test3check3: .string "\t[2] = 54321: "
test3check4: .string "\t[3] = 67890: "
test4name: .string "diff_lists - return correct diff: "

# Program main
.section .text
	call start

# TEST 1 - seek_num, seeks num
	la a0, test1name
	call print
	la a0, test1data
	call seek_num

	la a1, test1data
	addi a1, a1, 3 # str + 3 = '1'
	call test_eq

# TEST 2 - load_dual_list, loads 2x2 of numbers
	la a0, test2name
	call print
	la a0, test2data
	li a1, LIST1_POS
	li a2, LIST2_POS
	call load_dual_list
	mv t6, a0

	la a0, test2check1
	call print
	li a0, 12345
	li t1, LIST1_POS
	lw a1, 0(t1)
	call test_eq

	la a0, test2check2
	call print
	li a0,  9876
	lw a1, 4(t1)
	call test_eq

	la a0, test2check3
	call print
	li a0, 67890
	li t1, LIST2_POS
	lw a1, 0(t1)
	call test_eq

	la a0, test2check4
	call print
	li a0, 54321
	lw a1, 4(t1)
	call test_eq

	la a0, test2check5
	call print
	mv a0, t6
	mv a3, a0
	li a1, 8
	call test_eq

# TEST 3 - sort_list
	la a0, test3name
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
	la a0, test3check1
	call print
	li a0, 9876
	lw a1, 0(t1)
	call test_eq

	la a0, test3check2
	call print
	li a0,  12345
	lw a1, 4(t1)
	call test_eq

	la a0, test3check3
	call print
	li a0, 54321
	lw a1, 8(t1)
	call test_eq

	la a0, test3check4
	call print
	li a0, 67890
	lw a1, 12(t1)
	call test_eq

# TEST 4 - diff_lists
	la a0, test4name
	call print
	li t1, LIST1_POS
	li t0, 4
	sw t0, 0(t1)
	li t0, 8
	sw t0, 4(t1)
	li t1, LIST2_POS
	li t0, 10
	sw t0, 0(t1)
	li t0, 3
	sw t0, 4(t1)

	li a0, LIST1_POS
	li a1, LIST2_POS
	li a2, 8
	call diff_lists

	li a1, 11
	call test_eq
# Print end
	call end

# Loop forever after main execution
loop: j loop

