.section .lib

# vec_push - push to a vector
# a0 - vector_base pos
# a1 - address of item to push
# a2 - item size (multiples of 4 bytes)
.global vec_push
vec_push:
	addi sp, sp, -16
	sw ra, 0(sp)
	# get position of next empty space
	# get current size of vector
	# current size * item size
	# +
	# vector base + 4 (word size)
	# copy item into new pos
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# vec_get - get from a vector
# a0 - vector_base pos
# a1 - address to place item at
# a2 - item size (multiples of 4 bytes)
.global vec_get
vec_get:
	addi sp, sp, -16
	sw ra, 0(sp)
	# 
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
