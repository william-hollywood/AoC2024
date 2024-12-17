.section .data

.section .lib
.global test_libvec
test_libvec:
	addi sp, sp, -96
	sw ra, 0(sp)

	call test_libvec_at
	call test_libvec_push
	call test_libvec_insert
	call test_libvec_remove
	call test_libvec_find

	lw ra, 0(sp)
	addi sp, sp, 96
	ret
