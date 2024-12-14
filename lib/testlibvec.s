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

vec_insert1_1name: .string "vec_insert - size 1 insert at start: "
vec_insert1_2name: .string "vec_insert - size 1 insert at end: "
vec_insert1_3name: .string "vec_insert - size 1 insert in middle: "
vec_insert1_4name: .string "vec_insert - check contents: "
vec_insert2_1name: .string "vec_insert - size 2 insert at start: "
vec_insert2_2name: .string "vec_insert - size 2 insert at end: "
vec_insert2_3name: .string "vec_insert - size 2 insert in middle: "
vec_insert2_4name: .string "vec_insert - check contents: "
vec_insert4_1name: .string "vec_insert - size 4 insert at start: "
vec_insert4_2name: .string "vec_insert - size 4 insert at end: "
vec_insert4_3name: .string "vec_insert - size 4 insert in middle: "
vec_insert4_4name: .string "vec_insert - size 4 insert in middle again: "
vec_insert4_5name: .string "vec_insert - check contents: "
vec_insert8_1name: .string "vec_insert - size 8 insert at start: "
vec_insert8_2name: .string "vec_insert - size 8 insert at end: "
vec_insert8_3name: .string "vec_insert - size 8 insert in middle: "
vec_insert8_4name: .string "vec_insert - check contents: "
vec_insert12_1name: .string "vec_insert - size 12 insert at start: "
vec_insert12_2name: .string "vec_insert - size 12 insert at end: "
vec_insert12_3name: .string "vec_insert - size 12 insert in middle: "
vec_insert12_4name: .string "vec_insert - check contents: "

vec_remove1_1name: .string "vec_remove - size 1 remove at start: "
vec_remove1_2name: .string "vec_remove - size 1 remove at end: "
vec_remove1_3name: .string "vec_remove - size 1 remove in middle: "
vec_remove1_4name: .string "vec_remove - check contents: "
vec_remove2_1name: .string "vec_remove - size 2 remove at start: "
vec_remove2_2name: .string "vec_remove - size 2 remove at end: "
vec_remove2_3name: .string "vec_remove - size 2 remove in middle: "
vec_remove2_4name: .string "vec_remove - check contents: "
vec_remove4_1name: .string "vec_remove - size 4 remove at start: "
vec_remove4_2name: .string "vec_remove - size 4 remove at end: "
vec_remove4_3name: .string "vec_remove - size 4 remove in middle: "
vec_remove4_4name: .string "vec_remove - check contents: "
# 8 & 12 byte tests not implemented, I just can't be bothered. I need better test parameterization
vec_remove8_1name: .string "vec_remove - size 8 remove at start: "
vec_remove8_2name: .string "vec_remove - size 8 remove at end: "
vec_remove8_3name: .string "vec_remove - size 8 remove in middle: "
vec_remove8_4name: .string "vec_remove - check contents: "
vec_remove12_1name: .string "vec_remove - size 12 remove at start: "
vec_remove12_2name: .string "vec_remove - size 12 remove at end: "
vec_remove12_3name: .string "vec_remove - size 12 remove in middle: "
vec_remove12_4name: .string "vec_remove - check contents: "

.section .lib
.global test_libvec
test_libvec:
	addi sp, sp, -96
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
	call test_eq

	lw ra, 0(sp)
	addi sp, sp, 96
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

# a0 - name
# a1 - data addr to insert
# a2 - position to insert at
# a3 - item size
# a4 - expected len
test_vec_insert:
	addi sp, sp, -32
	sw ra, 0(sp)

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
	call vec_get

	lw a1, 4(sp)
	lw a2, 12(sp)
	call memcmp

	li a1, 0
	call test_eq
	j .L_test_vec_insert_end
.L_test_vec_insert_fail:
	li a0, 0
	li a1, 1
	call test_eq
.L_test_vec_insert_end:

	lw ra, 0(sp)
	addi sp, sp, 32
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
	call test_eq
	j .L_test_vec_remove_end
.L_test_vec_remove_fail:
	li a0, 0
	li a1, 1
	call test_eq
.L_test_vec_remove_end:

	lw ra, 0(sp)
	addi sp, sp, 32
	ret
