.section .data
.equ TEST_VEC, 0x87000000
vec_sort1_name: .string "vec_sort - size 1: "
vec_sort2_name: .string "vec_sort - size 2: "
vec_sort3_name: .string "vec_sort - size 4: "


.section .lib
.global test_libvec_sort
test_libvec_at:
	addi sp, sp, -96
	sw ra, 0(sp)

	# Yeah, I'll do this if i have time

	lw ra, 0(sp)
	addi sp, sp, 96
	ret
