.equ UART_BASE, 0x10000000

.section .data
helloworld: .string "Hello World\n"

.section .text
	la a0, helloworld
	li a1, UART_BASE
	call puts

loop: j loop

puts:
1:
	lb t0, 0(a0)
	beq zero, t0, 2f
	sb t0, (a1)
	addi a0, a0, 1
	j 1b
2:
	ret

