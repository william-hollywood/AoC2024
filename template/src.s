# Set UART_BASE for sending characters out
.equ UART_BASE, 0x10000000

# Input data of the puzzle
.section .data
helloworld: .string "Hello World\n"

# Program main
.section .text
	la a0, helloworld
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop

# puts - Output a string to the UART
# a0 string address
# a1 UART_BASE address
puts:
1:
	lb t0, 0(a0)
	beq zero, t0, 2f
	sb t0, (a1)
	addi a0, a0, 1
	j 1b
2:
	ret
