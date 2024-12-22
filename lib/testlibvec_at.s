.section .data
.equ TEST_VEC, 0x87000000
vec_at1_1name: .string "vec_at - size 1 pos 0"
vec_at1_2name: .string "vec_at - size 1 pos 1"
vec_at1_3name: .string "vec_at - size 1 pos 6"
vec_at1_4name: .string "vec_at - size 1 pos 7"
vec_at2_1name: .string "vec_at - size 2 pos 0"
vec_at2_2name: .string "vec_at - size 2 pos 1"
vec_at2_3name: .string "vec_at - size 2 pos 2"
vec_at2_4name: .string "vec_at - size 2 pos 3"
vec_at4_1name: .string "vec_at - size 4 pos 0"
vec_at4_2name: .string "vec_at - size 4 pos 3"
vec_at4_3name: .string "vec_at - size 4 pos 5"
vec_at8_1name: .string "vec_at - size 8 pos 0"
vec_at8_2name: .string "vec_at - size 8 pos 1"
vec_at8_3name: .string "vec_at - size 8 pos 2"
vec_at12_1name: .string "vec_at - size 12 pos 0"
vec_at12_2name: .string "vec_at - size 12 pos 1"

.section .lib
.global test_libvec_at
test_libvec_at:
	addi sp, sp, -96
	sw ra, 0(sp)

# TEST vec_at1/2
	# populate vec of len 8 with 1,2,3,4,5,6,7,8
	li t0, TEST_VEC
	li t1, 8
	sw t1, 0(t0)
	li t1, 0x04030201
	sw t1, 4(t0)
	li t1, 0x08070605
	sw t1, 8(t0)

	la a0, vec_at1_1name
	li a1, 0
	li a2, 1
	li a3, 1
	call test_vec_at

	la a0, vec_at1_2name
	li a1, 1
	li a2, 1
	li a3, 2
	call test_vec_at

	la a0, vec_at1_3name
	li a1, 6
	li a2, 1
	li a3, 7
	call test_vec_at

	la a0, vec_at1_4name
	li a1, 7
	li a2, 1
	li a3, 8
	call test_vec_at

	la a0, vec_at2_1name
	li a1, 0
	li a2, 2
	li a3, 0x0201
	call test_vec_at

	la a0, vec_at2_2name
	li a1, 1
	li a2, 2
	li a3, 0x0403
	call test_vec_at

	la a0, vec_at2_3name
	li a1, 2
	li a2, 2
	li a3, 0x0605
	call test_vec_at

	la a0, vec_at2_4name
	li a1, 3
	li a2, 2
	li a3, 0x0807
	call test_vec_at

# TEST vec_at4/8/12
	# populate vec of len 6 with 1,2,3,4,5,6
	li t0, TEST_VEC
	li t1, 6
	sw t1, 0(t0)
	li t1, 1
	sw t1, 4(t0)
	li t1, 2
	sw t1, 8(t0)
	li t1, 3
	sw t1, 12(t0)
	li t1, 4
	sw t1, 16(t0)
	li t1, 5
	sw t1, 20(t0)
	li t1, 6
	sw t1, 24(t0)

	la a0, vec_at4_1name
	li a1, 0
	li a2, 4
	li a3, 1
	call test_vec_at

	la a0, vec_at4_2name
	li a1, 3
	li a2, 4
	li a3, 4
	call test_vec_at

	la a0, vec_at4_3name
	li a1, 5
	li a2, 4
	li a3, 6
	call test_vec_at

	la a0, vec_at8_1name
	li a1, 0
	li a2, 8
	li a3, 1
	call test_vec_at

	la a0, vec_at8_2name
	li a1, 1
	li a2, 8
	li a3, 3
	call test_vec_at

	la a0, vec_at8_3name
	li a1, 2
	li a2, 8
	li a3, 5
	call test_vec_at

	la a0, vec_at12_1name
	li a1, 0
	li a2, 12
	li a3, 1
	call test_vec_at

	la a0, vec_at12_2name
	li a1, 1
	li a2, 12
	li a3, 4
	call test_vec_at

	lw ra, 0(sp)
	addi sp, sp, 96
	ret

# a0 - name
# a1 - get pos
# a2 - item size
# a3 - expected item
test_vec_at:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 16(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	call print

	li a0, TEST_VEC
	lw a1, 4(sp)
	lw a2, 8(sp)
	call vec_at
	li t0, 4
	lw t1, 8(sp)
	blt t1, t0, .L_test_vec_at_h
	lw a0, 0(a0)
	j .L_test_vec_at_end
.L_test_vec_at_h:
	li t0, 2
	bne t1, t0, .L_test_vec_at_b
	lh a0, 0(a0)
	j .L_test_vec_at_end
.L_test_vec_at_b:
	lb a0, 0(a0)
.L_test_vec_at_end:
	lw t0, 12(sp)
	mv a1, t0
	lw a2, 16(sp)
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
