.section .data
.equ TEST_VEC, 0x87000000

vec_insert1_1name: .string "vec_insert - size 1 insert at start"
vec_insert1_2name: .string "vec_insert - size 1 insert at end"
vec_insert1_3name: .string "vec_insert - size 1 insert in middle"
vec_insert1_4name: .string "vec_insert - size 1 check contents"
vec_insert2_1name: .string "vec_insert - size 2 insert at start"
vec_insert2_2name: .string "vec_insert - size 2 insert at end"
vec_insert2_3name: .string "vec_insert - size 2 insert in middle"
vec_insert2_4name: .string "vec_insert - size 2 check contents"
vec_insert4_1name: .string "vec_insert - size 4 insert at start"
vec_insert4_2name: .string "vec_insert - size 4 insert at end"
vec_insert4_3name: .string "vec_insert - size 4 insert in middle"
vec_insert4_4name: .string "vec_insert - size 4 insert in middle again"
vec_insert4_5name: .string "vec_insert - size 4 check contents"
vec_insert8_1name: .string "vec_insert - size 8 insert at start"
vec_insert8_2name: .string "vec_insert - size 8 insert at end"
vec_insert8_3name: .string "vec_insert - size 8 insert in middle"
vec_insert8_4name: .string "vec_insert - size 8 check contents"
vec_insert12_1name: .string "vec_insert - size 12 insert at start"
vec_insert12_2name: .string "vec_insert - size 12 insert at end"
vec_insert12_3name: .string "vec_insert - size 12 insert in middle"
vec_insert12_4name: .string "vec_insert - size 12 check contents"

.section .lib
.global test_libvec_insert
test_libvec_insert:
	addi sp, sp, -96
	sw ra, 0(sp)

# TEST vec_insert size 1
	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 1
	sb t0, 4(sp)
	la a0, vec_insert1_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 0
	li a3, 1
	li a4, 1
	call test_vec_insert

	li t0, 3
	sb t0, 4(sp)
	la a0, vec_insert1_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 1
	li a4, 2
	call test_vec_insert

	li t0, 2
	sb t0, 4(sp)
	la a0, vec_insert1_3name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 1
	li a4, 3
	call test_vec_insert

	# Check it's all as expected
	li t0, 3
	sw t0, 4(sp)
	li t0, 1
	sb t0, 8(sp)
	li t0, 2
	sb t0, 9(sp)
	li t0, 3
	sb t0, 10(sp)
	la a0, vec_insert1_4name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 7
	call memcmp
	li a1, 0
	call test_eq

# TEST vec_insert size 2
	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 1
	sh t0, 4(sp)
	la a0, vec_insert2_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 0
	li a3, 2
	li a4, 1
	call test_vec_insert

	li t0, 3
	sh t0, 4(sp)
	la a0, vec_insert2_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 2
	li a4, 2
	call test_vec_insert

	li t0, 2
	sh t0, 4(sp)
	la a0, vec_insert2_3name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 2
	li a4, 3
	call test_vec_insert

	# Check it's all as expected
	li t0, 3
	sw t0, 4(sp)
	li t0, 1
	sh t0, 8(sp)
	li t0, 2
	sh t0, 10(sp)
	li t0, 3
	sw t0, 12(sp)
	la a0, vec_insert2_4name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 10
	call memcmp
	li a1, 0
	call test_eq

# TEST vec_insert size 4
	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 1
	sw t0, 4(sp)
	la a0, vec_insert4_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 0
	li a3, 4
	li a4, 1
	call test_vec_insert

	li t0, 4
	sw t0, 4(sp)
	la a0, vec_insert4_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 4
	li a4, 2
	call test_vec_insert

	li t0, 3
	sw t0, 4(sp)
	la a0, vec_insert4_3name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 4
	li a4, 3
	call test_vec_insert

	li t0, 2
	sw t0, 4(sp)
	la a0, vec_insert4_4name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 4
	li a4, 4
	call test_vec_insert

	# Check it's all as expected
	li t0, 4
	sw t0, 4(sp)
	li t0, 1
	sw t0, 8(sp)
	li t0, 2
	sw t0, 12(sp)
	li t0, 3
	sw t0, 16(sp)
	li t0, 4
	sw t0, 20(sp)
	la a0, vec_insert4_5name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 20
	call memcmp
	li a1, 0
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 96
	ret

# a0 - name
# a1 - data addr to insert
# a2 - position to insert at
# a3 - item size
# a4 - expected len
test_vec_insert:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 20(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	call print

	li a0, TEST_VEC
	lw a1, 4(sp)
	lw a2, 8(sp)
	call vec_insert

	# test new len
	li a0, TEST_VEC
	lw a0, 0(a0)
	lw a1, 16(sp)
	bne a0, a1, .L_test_vec_insert_fail

	li a0, TEST_VEC
	lw a1, 8(sp)
	lw a2, 12(sp)
	call vec_at

	lw a1, 4(sp)
	lw a2, 12(sp)
	call memcmp

	li a1, 0
	lw a2, 20(sp)
	call test_eq
	j .L_test_vec_insert_end
.L_test_vec_insert_fail:
	li a0, 0
	li a1, 1
	lw a2, 20(sp)
	call test_eq
.L_test_vec_insert_end:

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
