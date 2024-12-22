.section .data
.equ TEST_VEC, 0x87000000

vec_remove1_1name: .string "vec_remove - size 1 remove at start"
vec_remove1_2name: .string "vec_remove - size 1 remove at end"
vec_remove1_3name: .string "vec_remove - size 1 remove in middle"
vec_remove1_4name: .string "vec_remove - check contents"
vec_remove2_1name: .string "vec_remove - size 2 remove at start"
vec_remove2_2name: .string "vec_remove - size 2 remove at end"
vec_remove2_3name: .string "vec_remove - size 2 remove in middle"
vec_remove2_4name: .string "vec_remove - check contents"
vec_remove4_1name: .string "vec_remove - size 4 remove at start"
vec_remove4_2name: .string "vec_remove - size 4 remove at end"
vec_remove4_3name: .string "vec_remove - size 4 remove in middle"
vec_remove4_4name: .string "vec_remove - check contents"
# 8 & 12 byte tests not implemented, I just can't be bothered. I need better test parameterization
vec_remove8_1name: .string "vec_remove - size 8 remove at start"
vec_remove8_2name: .string "vec_remove - size 8 remove at end"
vec_remove8_3name: .string "vec_remove - size 8 remove in middle"
vec_remove8_4name: .string "vec_remove - check contents"
vec_remove12_1name: .string "vec_remove - size 12 remove at start"
vec_remove12_2name: .string "vec_remove - size 12 remove at end"
vec_remove12_3name: .string "vec_remove - size 12 remove in middle"
vec_remove12_4name: .string "vec_remove - check contents"

.section .lib
.global test_libvec_remove
test_libvec_remove:
	addi sp, sp, -96
	sw ra, 0(sp)

# TEST vec_remove 1
	# Setup vec
	li t0, TEST_VEC
	li t1, 5
	sw t1, 0(t0)
	li t1, 1
	sb t1, 4(t0)
	li t1, 2
	sb t1, 5(t0)
	li t1, 3
	sb t1, 6(t0)
	li t1, 4
	sb t1, 7(t0)
	li t1, 5
	sb t1, 8(t0)
	la a0, vec_remove1_1name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 0
	li a3, 1
	li a4, 4
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 1
	sb t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove1_2name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 3
	li a3, 1
	li a4, 3
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 5
	sb t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove1_3name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 1
	li a3, 1
	li a4, 2
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 3
	sb t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	# Check it's all as expected
	li t0, 2
	sw t0, 4(sp)
	li t0, 2
	sb t0, 8(sp)
	li t0, 4
	sb t0, 9(sp)
	la a0, vec_remove1_4name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 6
	call memcmp
	li a1, 0
	la a2, vec_remove1_4name
	call test_eq

# TEST vec_remove 2
	# Setup vec
	li t0, TEST_VEC
	li t1, 5
	sw t1, 0(t0)
	li t1, 1
	sh t1, 4(t0)
	li t1, 2
	sh t1, 6(t0)
	li t1, 3
	sh t1, 8(t0)
	li t1, 4
	sh t1, 10(t0)
	li t1, 5
	sh t1, 12(t0)
	la a0, vec_remove2_1name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 0
	li a3, 2
	li a4, 4
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 1
	sh t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove2_2name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 3
	li a3, 2
	li a4, 3
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 5
	sh t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove2_3name
	mv a1, sp
	addi a1, a1, 16 # put data at 16(sp)
	li a2, 1
	li a3, 2
	li a4, 2
	mv a5, sp
	addi a5, a5, 32 # expect data at 32(sp)
	li t0, 3
	sh t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	# Check it's all as expected
	li t0, 2
	sw t0, 4(sp)
	li t0, 2
	sh t0, 8(sp)
	li t0, 4
	sh t0, 10(sp)
	la a0, vec_remove2_4name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 8
	call memcmp
	li a1, 0
	la a2, vec_remove2_4name
	call test_eq

# TEST vec_remove 4
	# Setup vec
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
	la a0, vec_remove4_1name
	mv a1, sp
	addi a1, a1, 32 # put data at 32(sp)
	li a2, 0
	li a3, 4
	li a4, 4
	mv a5, sp
	addi a5, a5, 64 # expect data at 64(sp)
	li t0, 1
	sw t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove4_2name
	mv a1, sp
	addi a1, a1, 32 # put data at 32(sp)
	li a2, 3
	li a3, 4
	li a4, 3
	mv a5, sp
	addi a5, a5, 64 # expect data at 64(sp)
	li t0, 5
	sw t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	la a0, vec_remove4_3name
	mv a1, sp
	addi a1, a1, 32 # put data at 32(sp)
	li a2, 1
	li a3, 4
	li a4, 2
	mv a5, sp
	addi a5, a5, 64 # expect data at 64(sp)
	li t0, 3
	sw t0, 0(a5) # expected data is 1 byte
	call test_vec_remove

	# Check it's all as expected
	li t0, 2
	sw t0, 4(sp)
	li t0, 2
	sw t0, 8(sp)
	li t0, 4
	sw t0, 12(sp)
	la a0, vec_remove4_4name
	call print
	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 12
	call memcmp
	li a1, 0
	la a2, vec_remove4_4name
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 96
	ret


# a0 - name
# a1 - data addr to put removed data
# a2 - position to remove from
# a3 - item size
# a4 - expected len
# a5 - expected data returned
test_vec_remove:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 28(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	sw a5, 20(sp)
	call print

	li a0, TEST_VEC
	mv a1, sp
	addi a1, a1, 24
	lw a2, 8(sp)
	lw a3, 12(sp)
	call vec_remove

	# test new len
	li a0, TEST_VEC
	lw a0, 0(a0)
	lw a1, 16(sp)
	bne a0, a1, .L_test_vec_remove_fail

	mv a0, sp
	addi a0, a0, 24
	lw a1, 20(sp)
	lw a2, 12(sp)
	call memcmp

	li a1, 0
	lw a2, 28(sp)
	call test_eq
	j .L_test_vec_remove_end
.L_test_vec_remove_fail:
	li a0, 0
	li a1, 1
	lw a2, 28(sp)
	call test_eq
.L_test_vec_remove_end:

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
