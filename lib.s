.section .lib
# gets - load the file from stdin into ram
# a0 - file buffer location
# a1 - READ location
.global gets
gets:
1: 
	lb t0, 0(a1)
	sb t0, (a0)
	beq zero, t0, 2f
	addi a0, a0, 1
	j 1b
2:
	ret

# puts - Output a string to an address
# a0 - string address
# a1 - WRITE location
.global puts
puts:
1:
	lb t0, 0(a0)
	beq zero, t0, 2f
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
	blt t0, zero, 2f
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
	addi t0, t0, 1
	bnez a0, 1f
	li t1, '0'
	sb t1, (t0)
	j 2f
1:
2:
3:
	blt t0, sp, 4f
	lb t1, (t0)
	sb t1, (a1)
	addi a1, a1, 1
	addi t0, t0, -1
	j 3b
4:
	addi sp, sp, 16
	ret
