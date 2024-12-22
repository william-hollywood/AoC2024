.section .data
.equ TEST_VEC, 0x87000000

vec_push1_1name: .string "vec_push - size 1 initially empty"
vec_push1_2name: .string "vec_push - size 1 contains item"
vec_push2_1name: .string "vec_push - size 2 initially empty"
vec_push2_2name: .string "vec_push - size 2 contains item"
vec_push4_1name: .string "vec_push - size 4 initially empty"
vec_push4_2name: .string "vec_push - size 4 contains item"
vec_push8_1name: .string "vec_push - size 8 initially empty"
vec_push8_2name: .string "vec_push - size 8 contains item"
vec_push12_1name: .string "vec_push - size 12 initially empty"
vec_push12_2name: .string "vec_push - size 12 contains item"

.section .lib
.global test_libvec_push
test_libvec_push:
	addi sp, sp, -96
	sw ra, 0(sp)

# TEST vec_push
	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 1
	sb t0, 4(sp)
	la a0, vec_push1_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 1
	call test_vec_push

	li t0, 2
	sb t0, 4(sp)
	la a0, vec_push1_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 1
	li a3, 2
	call test_vec_push

	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 0x0304
	sh t0, 4(sp)
	la a0, vec_push2_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 2
	li a3, 1
	call test_vec_push

	li t0, 0x0506
	sh t0, 4(sp)
	la a0, vec_push2_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 2
	li a3, 2
	call test_vec_push

	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 0x0708090a
	sw t0, 4(sp)
	la a0, vec_push4_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 4
	li a3, 1
	call test_vec_push

	li t0, 0x0b0c0d0e
	sw t0, 4(sp)
	la a0, vec_push4_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 4
	li a3, 2
	call test_vec_push

	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)

	li t0, 0x10111213
	sw t0, 4(sp)
	li t0, 0x14151617
	sw t0, 8(sp)
	la a0, vec_push8_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 8
	li a3, 1
	call test_vec_push

	li t0, 0x20212223
	sw t0, 4(sp)
	li t0, 0x24252627
	sw t0, 8(sp)
	la a0, vec_push8_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 8
	li a3, 2
	call test_vec_push

	# Set len to zero
	li t0, TEST_VEC
	li t1, 0
	sw t1, 0(t0)
	li t0, 0x30313233
	sw t0, 4(sp)
	li t0, 0x34353637
	sw t0, 8(sp)
	li t0, 0x38393a3b
	sw t0, 12(sp)
	la a0, vec_push12_1name
	mv a1, sp
	addi a1, a1, 4
	li a2, 12
	li a3, 1
	call test_vec_push

	li t0, 0x40414243
	sw t0, 4(sp)
	li t0, 0x44454647
	sw t0, 8(sp)
	li t0, 0x48494a4b
	sw t0, 12(sp)
	la a0, vec_push12_2name
	mv a1, sp
	addi a1, a1, 4
	li a2, 12
	li a3, 2
	call test_vec_push

	lw ra, 0(sp)
	addi sp, sp, 96
	ret


# a0 - name
# a1 - addr of item to push
# a2 - item size
# a3 - expected len
test_vec_push:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	call print

	li a0, TEST_VEC
	lw a1, 4(sp)
	lw a2, 8(sp)
	call vec_push

	li a0, TEST_VEC
	lw a0, 0(a0)
	mv a1, a3
	bne a0, a1, .L_test_vec_push_fail

	li a0, TEST_VEC
	lw a1, 12(sp)
	addi a1, a1, -1
	lw a2, 8(sp)
	call vec_at

	lw a1, 4(sp)
	lw a2, 12(sp)
	call memcmp

	li a1, 0
	call test_eq
	j .L_test_vec_push_end
.L_test_vec_push_fail:
	li a0, 0
	li a1, 1
	call test_eq
.L_test_vec_push_end:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
