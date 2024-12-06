.section .data
passedstr: .string "PASSED\n"
failedstr: .string "FAILED\n"

.section .lib
.global test_eq
test_eq:
	addi sp, sp, -16
	sw ra, 0(sp)
	bne a0, a1, 1f
	la a0, passedstr
	call print
	j 2f
1:
	la a0, failedstr
	call print
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

.global test_neq
test_neq:
	addi sp, sp, -16
	sw ra, 0(sp)
	beq a0, a1, 1f
	la a0, passedstr
	call print
	j 2f
1:
	la a0, failedstr
	call print
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
