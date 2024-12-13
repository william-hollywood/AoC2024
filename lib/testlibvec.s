.section .data
.equ TEST_VEC, 0x87000000
vec_get1_1name: .string "vec_get - size 1 pos 0: "
vec_get1_2name: .string "vec_get - size 1 pos 1: "
vec_get1_3name: .string "vec_get - size 1 pos 6: "
vec_get1_4name: .string "vec_get - size 1 pos 7: "
vec_get2_1name: .string "vec_get - size 2 pos 0: "
vec_get2_2name: .string "vec_get - size 2 pos 1: "
vec_get2_3name: .string "vec_get - size 2 pos 2: "
vec_get2_4name: .string "vec_get - size 2 pos 3: "
vec_get4_1name: .string "vec_get - size 4 pos 0: "
vec_get4_2name: .string "vec_get - size 4 pos 3: "
vec_get4_3name: .string "vec_get - size 4 pos 5: "
vec_get8_1name: .string "vec_get - size 8 pos 0: "
vec_get8_2name: .string "vec_get - size 8 pos 1: "
vec_get8_3name: .string "vec_get - size 8 pos 2: "
vec_get12_1name: .string "vec_get - size 12 pos 0: "
vec_get12_2name: .string "vec_get - size 12 pos 1: "

vec_push1_1name: .string "vec_push - size 1 initially empty: "
vec_push1_2name: .string "vec_push - size 1 contains item: "
vec_push2_1name: .string "vec_push - size 2 initially empty: "
vec_push2_2name: .string "vec_push - size 2 contains item: "
vec_push4_1name: .string "vec_push - size 4 initially empty: "
vec_push4_2name: .string "vec_push - size 4 contains item: "
vec_push8_1name: .string "vec_push - size 8 initially empty: "
vec_push8_2name: .string "vec_push - size 8 contains item: "
vec_push12_1name: .string "vec_push - size 12 initially empty: "
vec_push12_2name: .string "vec_push - size 12 contains item: "

.section .lib
.global test_libvec
test_libvec:
	addi sp, sp, -16
	sw ra, 0(sp)

# TEST vec_get1/2
	# populate vec of len 8 with 1,2,3,4,5,6,7,8
	li t0, TEST_VEC
	li t1, 8
	sw t1, 0(t0)
	li t1, 0x04030201
	sw t1, 4(t0)
	li t1, 0x08070605
	sw t1, 8(t0)

	la a0, vec_get1_1name
	li a1, 0
	li a2, 1
	li a3, 1
	call test_vec_get

	la a0, vec_get1_2name
	li a1, 1
	li a2, 1
	li a3, 2
	call test_vec_get

	la a0, vec_get1_3name
	li a1, 6
	li a2, 1
	li a3, 7
	call test_vec_get

	la a0, vec_get1_4name
	li a1, 7
	li a2, 1
	li a3, 8
	call test_vec_get

	la a0, vec_get2_1name
	li a1, 0
	li a2, 2
	li a3, 0x0201
	call test_vec_get

	la a0, vec_get2_2name
	li a1, 1
	li a2, 2
	li a3, 0x0403
	call test_vec_get

	la a0, vec_get2_3name
	li a1, 2
	li a2, 2
	li a3, 0x0605
	call test_vec_get

	la a0, vec_get2_4name
	li a1, 3
	li a2, 2
	li a3, 0x0807
	call test_vec_get

# TEST vec_get4/8/12
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

	la a0, vec_get4_1name
	li a1, 0
	li a2, 4
	li a3, 1
	call test_vec_get

	la a0, vec_get4_2name
	li a1, 3
	li a2, 4
	li a3, 4
	call test_vec_get

	la a0, vec_get4_3name
	li a1, 5
	li a2, 4
	li a3, 6
	call test_vec_get

	la a0, vec_get8_1name
	li a1, 0
	li a2, 8
	li a3, 1
	call test_vec_get

	la a0, vec_get8_2name
	li a1, 1
	li a2, 8
	li a3, 3
	call test_vec_get

	la a0, vec_get8_3name
	li a1, 2
	li a2, 8
	li a3, 5
	call test_vec_get

	la a0, vec_get12_1name
	li a1, 0
	li a2, 12
	li a3, 1
	call test_vec_get

	la a0, vec_get12_2name
	li a1, 1
	li a2, 12
	li a3, 4
	call test_vec_get

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
	addi sp, sp, 16
	ret

# a0 - name
# a1 - get pos
# a2 - item size
# a3 - expected item
test_vec_get:
	addi sp, sp, -16
	sw ra, 0(sp)

	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	call print

	li a0, TEST_VEC
	lw a1, 4(sp)
	lw a2, 8(sp)
	call vec_get
	li t0, 4
	lw t1, 8(sp)
	blt t1, t0, .L_test_vec_get_h
	lw a0, 0(a0)
	j .L_test_vec_get_end
.L_test_vec_get_h:
	li t0, 2
	bne t1, t0, .L_test_vec_get_b
	lh a0, 0(a0)
	j .L_test_vec_get_end
.L_test_vec_get_b:
	lb a0, 0(a0)
.L_test_vec_get_end:
	lw t0, 12(sp)
	mv a1, t0
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 16
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
	call vec_get

	lw a1, 4(sp)
	lw a2, 12(sp)
bp:
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
