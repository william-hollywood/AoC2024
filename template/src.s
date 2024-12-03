# Set UART_BASE for sending characters out
.equ UART_BASE, 0x10000000
.equ STACK_POS, 0x88000000

.section .data
helloworld: .string "Hello World\n"

# Program main
.section .text
	li sp, STACK_POS
	la a0, helloworld
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop
