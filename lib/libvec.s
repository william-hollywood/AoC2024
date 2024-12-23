.section .lib
# vec_at - get address of item from a vector
# a0 - vector_base pos
# a1 - position item to get
# a2 - item size
# Returns
# a0 - position of VEC[POS]
.global vec_at
vec_at:
	addi sp, sp, -16
	sw ra, 0(sp)
	# current size * item size
	mul t0, a1, a2
	# + vector base + 4 (word size)
	add t0, t0, a0
	addi t0, t0, 4
	mv a0, t0
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_push - push to a vector
# a0 - vector_base pos
# a1 - address of item to push
# a2 - item size
# returns
# a0 - new size of vector
.global vec_push
vec_push:
	addi sp, sp, -16
	sw ra, 0(sp)
	# vec_at current size plus one
	# copy item into new pos
	lw t0, 0(a0) # len
	addi t1, t0, 1
	sw t1, 0(a0)
	sw t1, 4(sp) # len to insert at
	# get position of next empty space
	mul t0, t0, a2 # offset from vec data
	add t0, t0, a0
	addi t0, t0, 4 # end pos
	# t0 is pos to insert at
	mv a0, a1
	mv a1, t0
	# a2 already len to copy
	call memcpy

	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_insert - insert into a vector
# a0 - vector_base pos
# a1 - address of item to be placed
# a2 - position of inserted item
# a3 - item size
.global vec_insert
vec_insert:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)

	# vec_at position of a1
	lw a0, 4(sp)
	lw a1, 12(sp)
	lw a2, 16(sp)
	call vec_at
	sw a0, 20(sp)

	lw a0, 4(sp)
	lw t0, 0(a0)
	addi t1, t0, 1
	sw t1, 0(a0)
	lw t1, 12(sp)
	beq t0, t1, .L_vec_insert_exit # if insert len is the end, skip moving items
	# vec_at position of new end
	lw a1, 0(a0)
	addi a1, a1, 1
	lw a2, 16(sp)
	call vec_at
	sw a0, 24(sp) # pos of end

.L_vec_insert_move_item:
	lw t0, 20(sp)
	lw t1, 24(sp)
	beq t0, t1, .L_vec_insert_exit

	# iterate backwards until a1
	lw a0, 24(sp)
	lw a1, 24(sp)
	lw a2, 16(sp)
	sub a0, a0, a2
	call memcpy

	lw t0, 24(sp)
	lw t1, 16(sp)
	sub t1, t0, t1
	sw t1, 24(sp)
	j .L_vec_insert_move_item

.L_vec_insert_exit:
	lw a0, 8(sp)
	lw a1, 20(sp)
	lw a2, 16(sp)
	call memcpy

	lw ra, 0(sp)
	addi sp, sp, 32
	ret

# vec_remove - remove from a vector, store result in a1
# a0 - vector_base pos
# a1 - address to place removed item at (ignored if x0)
# a2 - position of removed item
# a3 - item size
.global vec_remove
vec_remove:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)

	# vec_at position of a1
	lw a1, 12(sp)
	lw a2, 16(sp)
	call vec_at
	sw a0, 20(sp)

	lw a1, 8(sp)
	beqz a1, 1f
	lw a2, 16(sp)
	call memcpy
1:
	lw a0, 4(sp)
	lw t0, 0(a0)
	addi t1, t0, -1
	sw t1, 0(a0)
	lw t1, 12(sp)
	beq t0, t1, .L_vec_remove_exit # if remove pos is the end, skip moving items
	# vec_at position of new end
	mv a1, t0
	lw a2, 16(sp)
	call vec_at
	sw a0, 24(sp) # pos of end
.L_vec_remove_move_item:
	# iterate until at end
	lw a0, 20(sp)
	lw a1, 20(sp)
	lw a2, 16(sp)
	add a0, a0, a2
	sw a0, 20(sp)
	lw t1, 24(sp)
	beq a0, t1, .L_vec_remove_exit
	call memcpy
	j .L_vec_remove_move_item
.L_vec_remove_exit:

	lw ra, 0(sp)
	addi sp, sp, 32
	ret


# vec_find - find the first entry in the vector that matches the search data
# a0 - VEC base
# a1 - addr of data to find
# a2 - item size
# returns
# a0 - position of item or -1 if not found
.global vec_find
vec_find:
	addi sp, sp, -32
	sw ra, 0(sp)

	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)

	sw zero, 16(sp) # start search pos
	lw t0, 0(a0) # number of items
	beqz t0, .L_vec_find_not_found # not found if len is zero
	addi t0, t0, -1
	sw t0, 20(sp) # end num

.L_vec_find_loop:
	# check if mem at 16(sp) matches 8(sp)
	lw a0, 4(sp)
	lw a1, 16(sp)
	lw a2, 12(sp)
	call vec_at
	lw a1, 8(sp)
	call memcmp
	# if it does goto .L_vec_find_found
	beqz a0, .L_vec_find_found

	# otherwise, check if end of vec
	lw t0, 16(sp)
	lw t1, 20(sp)
	beq t0, t1, .L_vec_find_not_found
	# increment and repeat
	addi t0, t0, 1
	sw t0, 16(sp)
	j .L_vec_find_loop

.L_vec_find_not_found:
	li a0, -1
	j .L_vec_find_exit
.L_vec_find_found:
	lw a0, 16(sp)
.L_vec_find_exit:
	lw ra, 0(sp)
	addi sp, sp, 32
	ret
