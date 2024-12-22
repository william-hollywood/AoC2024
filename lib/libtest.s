.section .data
colon: .string ": "
newline: .string "\n"
ansi_green: .string "\033[32;1;4m"
ansi_red: .string "\033[31;1;4m"
ansi_white: .string "\033[0m"

hyphenspacer: .string "--------------------------------\n"
tests_str: .string " tests: "
hyphen: .string "\t- "
passedstr: .string "PASSED"
failedstr: .string "FAILED"
.equ FAIL_STR_VEC, 0x81000000
.equ TMP_STR_LOC, 0x878f0000
.equ PASS_COUNTER, 0x878ff000

.section .lib
.global test_start
test_start:
	addi sp, sp, -16
	sw ra, 0(sp)

	li t0, FAIL_STR_VEC
	sw zero, 0(t0)

	lw ra, 0(sp)
	addi sp, sp, 16
	ret

.global test_end
test_end:
	addi sp, sp, -16
	sw ra, 0(sp)

	la a0, hyphenspacer
	call print

	li t0, PASS_COUNTER
	lw t0, 0(t0)
	beqz t0, 1f

	la a0, ansi_green
	call print
	la a0, passedstr
	call print
	la a0, ansi_white
	call print
	la a0, tests_str
	call print

	li a0, PASS_COUNTER
	lw a0, 0(a0)
	la a1, TMP_STR_LOC
	call itos
	la a0, TMP_STR_LOC
	call print
	la a0, newline
	call print

1:
	# for string addr in FAIL_STR_VEC, print them
	li t0, FAIL_STR_VEC
	lw t0, 0(t0)
	beqz t0, .L_test_end_exit
	sw zero, 4(sp)
	sw t0, 8(sp)

	la a0, ansi_red
	call print
	la a0, failedstr
	call print
	la a0, ansi_white
	call print
	la a0, tests_str
	call print

	lw a0, 8(sp)
	la a1, TMP_STR_LOC
	call itos
	la a0, TMP_STR_LOC
	call print
	la a0, newline
	call print


.L_test_end_loop:
	lw t0, 4(sp)
	lw t1, 8(sp)
	beq t0, t1, .L_test_end_exit

	la a0, hyphen
	call print

	li a0, FAIL_STR_VEC
	lw a1, 4(sp)
	li a2, 4
	call vec_at
	lw a0, 0(a0)
	call print

	la a0, newline
	call print

	lw t0, 4(sp)
	addi t0, t0, 1
	sw t0, 4(sp)
	j .L_test_end_loop
.L_test_end_exit:
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

# test_(n)eq - test if a thing is equal or not
# a0 - thing 1
# a1 - thing 2
# a2 - string of test
.global test_neq
test_neq:
	addi sp, sp, -16
	sw ra, 0(sp)
	sw a2, 4(sp)
	beq a0, a1, 2f
	j 1f
.global test_eq
test_eq:
	addi sp, sp, -16
	sw ra, 0(sp)
	sw a2, 4(sp)
	bne a0, a1, 2f
1:
	call print_pass
	li t0, PASS_COUNTER
	lw t1, 0(t0)
	addi t1, t1, 1
	sw t1, 0(t0)
	j 3f
2:
	call print_fail
	li a0, FAIL_STR_VEC
	mv a1, sp
	addi a1, a1, 4
	li a2, 4
	call vec_push
3:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
