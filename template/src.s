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
