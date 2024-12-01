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
	li t0, 0
1:
	lb t0, 0(a0)
	addi t0, t0, -'0'
	li t3, 10
	bge t0, t3, 2f
	mul t1, t1, t3
	add t1, t0, t1
	j 1b
2:
	mv a0, t1
	ret

.global itos
itos:
	ret
