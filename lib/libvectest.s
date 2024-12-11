.section .lib
.global test_libvec
test_libvec:
	addi sp, sp, -16
	sw ra, 0(sp)

	# TODO

	lw ra, 0(sp)
	addi sp, sp, 16
	ret
