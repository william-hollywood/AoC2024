.section .lib
# vec_get - get address of item from a vector
# a0 - vector_base pos
# a1 - position item to get
# a2 - item size (multiples of 1, 2 or 4 bytes)
# Returns
# a0 - position of VEC[POS]
.global vec_get
vec_get:
	addi sp, sp, -16
	sw ra, 0(sp)
	# current size * item size
	# +
	# vector base + 4 (word size)
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_push - push to a vector
# a0 - vector_base pos
# a1 - address of item to push
# a2 - item size (multiples of 1, 2 or 4 bytes)
.global vec_push
vec_push:
	addi sp, sp, -16
	sw ra, 0(sp)
	# get position of next empty space
	# vec_get current size plus one
	# copy item into new pos
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_insert - insert into a vector
# a0 - vector_base pos
# a1 - address to place item at
# a2 - position of inserted item
# a2 - item size (multiples of 1, 2 or 4 bytes)
.global vec_insert
vec_insert:
	addi sp, sp, -16
	sw ra, 0(sp)
	# vec_get position of a1
	# vec_get position of end
	# iterate backwards until a1
	# if at a1, exit
	# movie pos - 1 into pos
	# repeat
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_remove - remove from a vector
# a0 - vector_base pos
# a1 - address to place item at
# a2 - position of removed item
# a2 - item size (multiples of 1, 2 or 4 bytes)
.global vec_remove
vec_remove:
	addi sp, sp, -16
	sw ra, 0(sp)
	# cursor = a1
	# iterate until end of vec
	# if at end of vec exit
	# vec_get position of cursor
	# move cusor + 1 into current
	# repeat
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
