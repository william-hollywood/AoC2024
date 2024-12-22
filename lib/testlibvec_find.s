.section .data
.equ TEST_VEC, 0x87000000

vec_find1_name: .string "vec_find - find at start"
vec_find2_name: .string "vec_find - find in middle"
vec_find3_name: .string "vec_find - find at end"
vec_find4_name: .string "vec_find - item not found"

.section .lib
.global test_libvec_find
test_libvec_find:
	addi sp, sp, -96
	sw ra, 0(sp)

	# populate test vector
	li t0, TEST_VEC
	li t1, 5
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
	sw t1, 24(t0) # make sure we don't scan past the end

	mv t0, sp
	addi t0, t0, 32
	sw t0, 28(sp) # expected data location (put expected data into 28(sp))

	la a0, vec_find1_name
	lw a1, 28(sp)
	li a2, 0 # expected return pos
	li a3, 4 # item size
	li t0, 1 # data to look for
	sw t0, 32(sp)
	call test_vec_find

	la a0, vec_find2_name
	lw a1, 28(sp)
	li a2, 2 # expected return pos
	li a3, 4 # item size
	li t0, 3 # data to look for
	sw t0, 32(sp)
	call test_vec_find

	la a0, vec_find3_name
	lw a1, 28(sp)
	li a2, 4 # expected return pos
	li a3, 4 # item size
	li t0, 5 # data to look for
	sw t0, 32(sp)
	call test_vec_find

	la a0, vec_find4_name
	lw a1, 28(sp)
	li a2, -1 # expected return pos
	li a3, 4 # item size
	li t0, 6 # data to look for
	sw t0, 32(sp)
	call test_vec_find

	lw ra, 0(sp)
	addi sp, sp, 96
	ret


# a0 - test name
# a1 - data to find addr
# a2 - expected position
# a3 - item size
test_vec_find:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	call print

	li a0, TEST_VEC
	lw a1, 4(sp)
	lw a2, 12(sp)
	call vec_find
	lw a1, 8(sp)
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
