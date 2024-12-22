.section .data
colon: .string ": "
newline: .string "\n"
ansi_green: .string "\033[32;1;4m"
ansi_red: .string "\033[31;1;4m"
ansi_white: .string "\033[0m"

passedstr: .string "PASSED"
failedstr: .string "FAILED"
.equ FAIL_STR_VEC, 0x81000000

.section .lib
.global test_start
test_start:
	addi sp, sp, -16
	sw ra, 0(sp)

	li t0, FAIL_STR_VEC

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

.global test_end
test_end:
	addi sp, sp, -16
	sw ra, 0(sp)

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

print_fail:
	addi sp, sp, -16
	sw ra, 0(sp)
	li t0, 0
	j 1f
print_pass:
	addi sp, sp, -16
	sw ra, 0(sp)
	li t0, 1
1:
	sw t0, 4(sp)

	la a0, colon
	call print
	lw t0, 4(sp)
	beqz t0, 2f
	la a0, ansi_green
	call print
	la a0, passedstr
	call print
	j 3f
2:
	la a0, ansi_red
	call print
	la a0, failedstr
	call print
3:
	la a0, ansi_white
	call print
	la a0, newline
	call print

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

.global test_neq
test_neq:
	addi sp, sp, -16
	sw ra, 0(sp)
	beq a0, a1, 1f
	j 2f
.global test_eq
test_eq:
	addi sp, sp, -16
	sw ra, 0(sp)
	bne a0, a1, 1f
	call print_pass
	j 2f
1:
	call print_fail
2:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
