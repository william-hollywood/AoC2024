.equ STACK_POS, 0x88000000
.equ UART_BASE, 0x10000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "-----\nFin.\n-----\n"

.section .lib

# This is a template
.global template
template:
	li sp, STACK_POS
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# start - print out a start message and initialize the stack pointer
.global start
start:
	li sp, STACK_POS
	addi sp, sp, -16
	sw ra, 0(sp)
	la a0, startstr
	call print
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# end - print out an end message
.global end
end:
	addi sp, sp, -16
	sw ra, 0(sp)
	la a0, endstr
	call print
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# print - print a message to the UART out
# a0 - address of string to print
.global print
print:
	addi sp, sp, -16
	sw ra, 0(sp)
	li a1, UART_BASE
	call puts
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# check_eq_mem - Compare two memory region with length a2
# a0 - mem address 1
# a1 - mem address 2
# a2 - length of memory to compare
.global check_eq_mem
check_eq_mem:
	addi sp, sp, -16
	sw ra, 0(sp)
	li t0, 0
	mv t1, a2
1:
	beqz t1, 3f
	lb t2, (a0)
	lb t3, (a1)
	beq t2, t3, 2f
	addi t0, t0, 1
2:
	addi a0, a0, 1
	addi a1, a1, 1
	addi t1, t1, -1
	j 1b
3:
	mv a0, t0
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# gets - load the file from stdin into ram
# a0 - file buffer location
# a1 - READ location
.global gets
gets:
1:
	lb t0, 0(a1)
	sb t0, (a0)
	addi a0, a0, 1
	beqz t0, 4f
2:
	lb t1, 5(a1)
	andi t1, t1, 1
	bnez t1, 3f
	j 2b
3:
	j 1b
4:
	li t0, 0
	sb t0, (a0)
	ret

# puts - Output a string to an address
# a0 - string address
# a1 - WRITE location
.global puts
puts:
1:
	lb t0, 0(a0)
	beqz t0, 2f
	sb t0, (a1)
	addi a0, a0, 1
	j 1b
2:
	ret

# stoi - parse a string as an int, read until first non-int character
# a0 - string address
.global stoi
stoi:
	li t1, 0
1:
	lb t0, 0(a0)
	addi t0, t0, -'0'
	li t3, 9
	bge t0, t3, 2f
	blez t0, 2f
	li t3, 10
	mul t1, t1, t3
	add t1, t0, t1
	addi a0, a0, 1
	j 1b
2:
	mv a0, t1
	ret

# itos - turn an integer into a string and store it at the given address
# a0 - integer
# a1 - Store string location
.global itos
itos:
	addi sp, sp, -16
	mv t0, sp
	li t1, 0
	sb t1, (t0)
	bnez a0, 1f # If not zero jump to 1
	li t1, '0' # is zero, so add a zero
	addi t0, t0, 1
	sb t1, (t0)
	j 3f
1: # non zero number, check if negative, set t6 if is
	bgez a0, 2f # If non-negative jump to 2
	li t6, 1
	neg a0, a0
2:
	li t5, 10
	rem t1, a0, t5
	div a0, a0, t5
	addi t1, t1, '0'
	addi t0, t0, 1
	sb t1, (t0)
	bnez a0, 2b # If not zero repeat
	beqz t6, 3f # If t6 zero repeat, dont add '-'
	li t1, '-' # is zero, so add a zero
	addi t0, t0, 1
	sb t1, (t0)
3: # spit the string made into pointer a1
	blt t0, sp, 4f
	lb t1, (t0)
	sb t1, (a1)
	addi a1, a1, 1
	addi t0, t0, -1
	j 3b
4:
	addi sp, sp, 16
	ret
